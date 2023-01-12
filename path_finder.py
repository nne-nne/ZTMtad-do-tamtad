from DataLoader import DataLoader


class PathFinder:
    def __init__(self, data_loader: DataLoader):
        self.dataLoader = data_loader

    def first_departure_from_ways(self, departures, ways):
        for departure in departures:
            if (departure['routeId'], departure['tripId']) in ways:
                return departure

    def first_departure_from_stop_ids(self, stop_1_id, stop_2_id):
        departures = self.dataLoader.departures[str(stop_1_id)]['departures']
        if len(departures) == 0:
            return None
        connections = self.dataLoader.route_finder(stop_1_id, stop_2_id)
        if len(connections) == 0:
            return
        best_departure = self.first_departure_from_ways(departures, connections)
        return best_departure
