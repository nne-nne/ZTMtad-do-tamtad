import json

from DataLoader import DataLoader

import json
from datetime import datetime

from DataLoader import DataLoader
from path import Path, PathSegment
from WayFinder import WayFinder
from itertools import product

from path import Path, PathSegment



class PathFinder:
    def __init__(self, data_loader: DataLoader):
        self.dataLoader = data_loader
        self.way_finder = WayFinder(self.dataLoader)

    @staticmethod
    def first_departure_from_ways(departures, ways):
        for departure in departures:
            if (departure['routeId'], departure['tripId']) in ways:
                return departure

    def first_departure_from_stop_ids(self, stop_1_id, stop_2_id):
        departures = self.dataLoader.departures[str(stop_1_id)]['departures']
        if len(departures) == 0:
            return None
        connections = self.dataLoader.route_finder_dep(stop_1_id, stop_2_id, departures)
        if len(connections) == 0:
            return
        best_departure = PathFinder.first_departure_from_ways(departures, connections)
        return best_departure

    def stopnames_user_request_handler(self, stop1_str, stop2_str):
        # dostajemy od użytkownika dwa parametry stopDesc przystanków
        # czyli na przykład "Gdańsk Wrzeszcz", "Brama Wyżynna"
        # trzeba wywołać magiczny algorytm dla wszystkich stopId, które pasują
        # i wysłać w wyniku kilka najlepszych tras (Path)

        print(stop1_str, ' -> ', stop2_str)
        a = product(*[self.dataLoader.stop_names[stop1_str], self.dataLoader.stop_names[stop2_str]])
        results = self.way_finder.complex_find(a)
        # poniżej przykład:
        final = []
        for result in results:
            minutes = lambda x: int((datetime.strptime(x['arrival'], '%H:%M:%S') - datetime.strptime(x['start'], '%H:%M:%S')).seconds/60)
            # try:
            paths = [PathSegment(str(x['routeId']), self.dataLoader.yyy[x['routeId']]['routeType'], minutes(x), x['start'], self.dataLoader.stop_dict.get(x['stopId'])['stopDesc']) for x in result]
            # except:
            #     paths = []
            # ps1 = PathSegment("6", "TRAM", 13, "2023-01-13T06:30", "Miszewskiego")
            # ps2 = PathSegment("5", "TRAM", 7, "2023-01-13T06:45", "Jaśkowa Dolina")
            # ps3 = PathSegment("154", "BUS", 22, "2023-01-13T06:59", "Klonowa")
            try:
                p1 = Path(int((datetime.strptime(result[-1]['arrival'], '%H:%M:%S') - datetime.strptime(result[0]['start'], '%H:%M:%S')).seconds/60), paths, result[-1]['arrival'])
            except:
                p1 = Path(0, paths, result[-1]['arrival'])
            # p2 = Path(23, [ps1, ps2], "2023-01-13T07:01")
            final += [p1]

        return final


if __name__ == '__main__':
    dl = DataLoader().full_prepare()
    pf = PathFinder(dl)
    a = pf.stopnames_user_request_handler('Łostowice Świętokrzyska', 'Gdańska')
    print(a[0].to_json(), a[1].to_json(), a[2].to_json())

