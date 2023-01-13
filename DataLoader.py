import json
from pprint import pprint
from tqdm import tqdm
from datetime import datetime

from webservice import Webservice

route_url = "https://ckan.multimediagdansk.pl/dataset/c24aa637-3619-4dc2-a171-a23eec8f2172/resource/22313c56-5acf-41c7-a5fd-dc5dc72b3851/download/routes.json"
departures_url = "https://ckan2.multimediagdansk.pl/departures"
stops_url = "https://ckan.multimediagdansk.pl/dataset/c24aa637-3619-4dc2-a171-a23eec8f2172/resource/4c4025f0-01bf-41f7-a39f-d156d201b82b/download/stops.json"
trips_url = "https://ckan.multimediagdansk.pl/dataset/c24aa637-3619-4dc2-a171-a23eec8f2172/resource/b15bb11c-7e06-4685-964e-3db7775f912f/download/trips.json"
stopsintrip_url = "https://ckan.multimediagdansk.pl/dataset/c24aa637-3619-4dc2-a171-a23eec8f2172/resource/3115d29d-b763-4af5-93f6-763b835967d6/download/stopsintrip.json"


class DataLoader:
    def __init__(self):
        self.route_trip = None  # dict ze wszystkimi route i przynależących do nich tripów w formie listy
        self.routes = None
        self.departures = None
        self.stops = None
        self.trips = None
        self.stopsintrip = None
        self.stop_dict = None  # dict informacji o stopach, klucze to stopID
        self.trips_stops = None  # dict, kluczem jest krokta (routeID, tripID), wartość to lista stopID na trasie
        self.stop_tp = None  # stopId na pary routeId, tripId
        self.stops_connections_next = None
        self.stops_connections_prev = None
        self.rozklad_jazdy = None  # jazda z
        self.date = datetime.today().strftime('%Y-%m-%d')

    def full_prepare(self):
        #self.load_from_files()
        self.download_data()
        self.create_stop_dict().create_route_trip()
        self.create_trips_stops().create_stops_connections()
        return self

    def download_data(self):
        webservice = Webservice()
        self.routes = webservice.getJson(route_url)
        self.departures = webservice.getJson(departures_url)
        self.stops = webservice.getJson(stops_url)
        self.trips = webservice.getJson(trips_url)
        self.stopsintrip = webservice.getJson(stopsintrip_url)

    def load_from_files(self) -> object:
        with open('Data/routes.json', 'r', encoding='utf8') as f:
            self.routes = json.load(f)
        with open('Data/departures.json', 'r', encoding='utf8') as f:
            self.departures = json.load(f)
        with open('Data/stops.json', 'r', encoding='utf8') as f:
            self.stops = json.load(f)
        with open('Data/trips.json', 'r', encoding='utf8') as f:
            self.trips = json.load(f)
        with open('Data/stopsintrip.json', 'r', encoding='utf8') as f:
            self.stopsintrip = json.load(f)
        return self

    def create_stops_connections(self):
        self.stops_connections_next = {x: [] for x in self.stop_dict.keys()}
        for x in tqdm(self.trips_stops.keys(), desc='stops connections'):
            for i, stop in enumerate(self.trips_stops[x]):
                self.stops_connections_next[stop] += self.trips_stops[x][i:]
                self.stops_connections_next[stop] = list(set(self.stops_connections_next[stop]))
        return self

    def create_trips_stops(self):
        route_trip = dict(self.route_trip)
        self.trips_stops = dict()
        self.stop_tp = dict()
        for z in tqdm(route_trip.keys()):
            for y in route_trip[z]:
                a = [x for x in self.stopsintrip[self.date]['stopsInTrip'] if
                     x['tripId'] == y and x['routeId'] == z]
                a = sorted(a, key=lambda x: x['stopSequence'], reverse=False)
                names = [x['stopId'] for x in a]
                self.trips_stops.update({(z, y): names})
        return self

    def route_finder(self, id1, id2):
        ways = []
        for r, t in self.trips_stops.keys():
            trip = self.trips_stops[(r, t)]
            if id1 in trip and id2 in trip and trip.index(id1) < trip.index(id2):
                ways.append((r, t))
        return ways

    def route_finder_dep(self, id1, id2, departures):
        deps = [(d['routeId'], d['tripId']) for d in departures]
        deps = list(set(deps))
        possible_ways = [x for x in self.trips_stops.keys() if x in deps]
        print(possible_ways)
        ways = []
        for r, t in possible_ways:
            trip = self.trips_stops[(r, t)]
            if id1 in trip and id2 in trip and trip.index(id1) < trip.index(id2):
                ways.append((r, t))
        # print(ways)
        ways_ = dict()
        fixed = []
        if len(ways) == 0:
            print('trying')
            for id in self.stops_connections_next[id1]:
                new_ways_ = self.route_finder(id, id2)
                if len(new_ways_) > 0:
                    fixed = self.route_finder(id1, id)
                    ways_.update({id: (fixed, new_ways_)})

        print('ways_')
        pprint(ways_)
        return ways


    def create_stop_dict(self):
        self.stop_dict = {x['stopId']: x for x in self.stops[self.date]['stops']}
        return self

    def create_route_trip(self):
        route_trip = {x['routeId']: [] for x in self.routes[self.date]['routes']}
        for x in self.trips[self.date]['trips']:
            route_trip.update({x['routeId']: route_trip[x['routeId']] + [x['tripId']]})
        self.route_trip = route_trip
        return self

    def r_t_route(self, r_id, t_id):
        a = [x for x in self.stopsintrip[self.date]['stopsInTrip'] if x['tripId'] == t_id and x['routeId'] == r_id]
        a = sorted(a, key=lambda x: x['stopSequence'], reverse=False)
        # print(a)
        for x in a:
            # print(x['stopId'], stop_dict[x['stopId']]['stopName'])
            x.update({'stopName': self.stop_dict[x['stopId']]['stopName']})
            # print(x)
        # a = [ for x in a]
        print([x['stopName'] for x in a])
        # pprint(a)

    def test(self):
        self.r_t_route(2, 32)
        self.r_t_route(3, 32)
        self.r_t_route(4, 32)
        # self.r_t_route(2, 32)
        # self.r_t_route(2, 22)


if __name__ == "__main__":
    dl = DataLoader().full_prepare()
    pprint(dl.stop_dict[201])
    pprint(dl.stop_dict[2231])
    pprint(dl.stop_dict[221])
    # pprint(dl.trips_stops)
    # print(dl.route_finder(292, 209))
    # print(dl.route_finder(209, 292))
    # for x in dl.stop_dict.keys():
    #     if dl.stop_dict[x]['stopName'] == 'Miszewskiego':
    #         pprint(dl.stop_dict[x])
    # dl.test()
