import json

from DataLoader import DataLoader
from path import Path, PathSegment


class PathFinder:
    def __init__(self, data_loader: DataLoader):
        self.dataLoader = data_loader

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

        # poniżej przykład:
        ps1 = PathSegment("6", "TRAM", 13, "2023-01-13T06:30", "Miszewskiego")
        ps2 = PathSegment("5", "TRAM", 7, "2023-01-13T06:45", "Jaśkowa Dolina")
        ps3 = PathSegment("154", "BUS", 22, "2023-01-13T06:59", "Klonowa")
        p1 = Path(58, [ps1, ps2, ps3], "2023-01-13T07:25")
        p2 = Path(23, [ps1, ps2], "2023-01-13T07:01")
        result = [p1, p2]

        return result
