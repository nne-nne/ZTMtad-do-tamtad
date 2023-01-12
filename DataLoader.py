import json
from pprint import pprint
from tqdm import tqdm


class DataLoader:
    def __init__(self):
        self.route_trip = None  # dict ze wszystkimi route i przynależących do nich tripów w formie listy
        self.routes = None
        self.departures = None
        self.stops = None
        self.trips = None
        self.stopsintrip = None
        self.stop_dict = None  # dict informacji o stopach, klucze to stopID
        self.trips_stops = None # dict, kluczem jest krokta (routeID, tripID), wartość to lista stopID na trasie

    def full_prepare(self):
        self.load_from_files().create_stop_dict().create_route_trip()
        self.create_trips_stops()
        return self

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

    def create_trips_stops(self):
        route_trip = dict(self.route_trip)
        self.trips_stops = dict()
        for z in tqdm(route_trip.keys()):
            for y in route_trip[z]:
                a = [x for x in self.stopsintrip['2023-01-12']['stopsInTrip'] if
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

    def create_stop_dict(self):
        self.stop_dict = {x['stopId']:x for x in self.stops['2023-01-12']['stops']}
        return self

    def create_route_trip(self):
        route_trip = {x['routeId']: [] for x in self.routes['2023-01-12']['routes']}
        for x in self.trips['2023-01-12']['trips']:
            route_trip.update({x['routeId']: route_trip[x['routeId']] + [x['tripId']]})
        self.route_trip = route_trip
        return self

    def r_t_route(self, r_id, t_id):
        a = [x for x in self.stopsintrip['2023-01-12']['stopsInTrip'] if x['tripId'] == t_id and x['routeId'] == r_id]
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
    # pprint(dl.trips_stops)
    print(dl.route_finder(292, 209))
    print(dl.route_finder(209, 292))
    # for x in dl.stop_dict.keys():
    #     if dl.stop_dict[x]['stopName'] == 'Miszewskiego':
    #         pprint(dl.stop_dict[x])
    # dl.test()
