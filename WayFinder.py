from DataLoader import DataLoader
from pprint import pprint
from TimetableLoader import TimetableLoader
from datetime import datetime
import itertools


class WayFinder:
    def __init__(self, data_loader: DataLoader):
        self.data_loader = data_loader
        self.timetable = TimetableLoader()

    def find_way(self, id1, id2):
        departures = self.data_loader.departures[str(id1)]['departures']
        ways = self.ways_in_departures(departures)
        possible_ways = self.check_ways_connection(id1, id2, ways)
        # pprint(possible_ways)
        possible_ways = self.find_lowest_connections(possible_ways)
        closest_ways = [x for x in possible_ways if len(x) == len(possible_ways[0])]
        pprint(closest_ways)
        possible_departures = self.decode_to_departures(closest_ways, departures)

        for i, route in enumerate(possible_departures):
            ids = [x[2] for x in closest_ways[i]] + [id2]
            for i, way in enumerate(route):
                if i == 0:
                    start, stop = self.find_route_time(way, ids[i], ids[i+1])
                    way.update({'start': start.strftime('%H:%M:%S'), 'arrival': stop.strftime('%H:%M:%S'),
                                'stopId': ids[i], 'nextStopId': ids[i+1]})
                else:
                    routeId, day, hour = self.timetable.decode_departure(way)
                    hour = route[i-1]['arrival']
                    way = self.timetable.find_next(routeId, way['tripId'], day, ids[i], hour)
                    if way is None:
                        continue
                    start, stop = self.find_route_time(way, ids[i], ids[i+1])
                    way.update({'start': start.strftime('%H:%M:%S'), 'arrival': stop.strftime('%H:%M:%S'),
                                'stopId': ids[i], 'nextStopId': ids[i+1]})
                    route[i] = way

        # pprint(possible_departures)
        return possible_departures

    def push_time(self, way, prev_arrival):
        pass

    def find_route_time(self, departure, stopId, nextId):
        routeId, day, hour = self.timetable.decode_departure(departure)
        start = datetime.strptime(hour, '%H:%M:%S')
        last = self.timetable.find_dep(routeId, day, hour, stopId, nextId)
        finish = last['arrivalTime'].split('T')[1]
        finish = datetime.strptime(finish, '%H:%M:%S')
        return start, finish

    def find_lowest_connections(self, ways):
        sorted_ways = sorted(ways, key=lambda x: len(x), reverse=False)

        return sorted_ways

    def ways_in_departures(self, departures):
        ways = [(x['routeId'], x['tripId']) for x in departures]
        ways = list(set(ways))
        return ways

    def check_ways_connection(self, id1, id2, ways, recursion_count=0):
        if recursion_count > 2:
            return []
        new_ways = []
        for r, t in ways:
            trip = self.data_loader.trips_stops[(r, t)]
            if id1 in trip and id2 in trip and trip.index(id1) < trip.index(id2):
                if recursion_count == 0:
                    new_ways.append([(r, t, id1)])
                else:
                    new_ways.append([(r, t, id1)])

        if len(new_ways) == 0:
            ways_ = []
            for id in self.data_loader.stops_connections_next[id1]:
                id_ways = self.ways_in_departures(self.data_loader.departures[str(id)]['departures'])
                new_ways_ = self.check_ways_connection(id, id2, id_ways, recursion_count=recursion_count+1)
                if len(new_ways_) > 0:
                    fixed = self.check_ways_connection(id1, id, ways, recursion_count=recursion_count+1)
                    ways_ += self.product(fixed, new_ways_)

            new_ways = ways_
        return new_ways

    def product(self, fixed, new_ways):
        new_ways_ = []
        for x in fixed:
            for y in new_ways:
                new_ways_.append(x+y)
        return new_ways_

    def decode_to_departures(self, ways_lists, departures):
        new_departures_list = []
        for i, ways in enumerate(ways_lists):
            new_departures_list.append(
                [self.first_departure_to_match(way, self.data_loader.departures[str(way[2])]['departures']) for way in ways])
        return new_departures_list

    def first_departure_to_match(self, way, departures):
        for departure in departures:
            if departure['routeId'] == way[0] and departure['tripId'] == way[1]:
                return departure
        return None

    def complex_find(self, id1, id2):
        a = self.find_way(id1, id2)
        a = [x for x in a if x[-1].get('arrival') is not None]
        a = sorted(a, key=lambda x: datetime.strptime(x[-1].get('arrival'), '%H:%M:%S'))
        for x in a:
            print(x[0].get('start'), x[-1].get('arrival'))
        return a[0]

if __name__ == '__main__':
    dl = DataLoader().full_prepare()
    # pprint(dl.stops_connections_next)
    wf = WayFinder(dl)
    pprint(wf.complex_find(2231, 2181))
    # pprint(wf.find_way(201, 221))
