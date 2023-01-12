from DataLoader import DataLoader
from pprint import pprint
from path_finder import PathFinder


class UserInput:
    def __init__(self, data_loader: DataLoader, path_finder:PathFinder):
        self.dataLoader = data_loader
        self.pathFinder = path_finder

    def are_stops_connected_dialogue(self):
        print("where are you? (stop id)")
        stop_1_id = int(input())  # e.g. 2148
        print("where do you want to be? (stop id)")
        stop_2_id = int(input())    # e.g. 2149
        print("your route:")
        print(self.dataLoader.stop_dict[stop_1_id]['stopDesc'], '->', self.dataLoader.stop_dict[stop_2_id]['stopDesc'])
        best_departure = self.pathFinder.first_departure_from_stop_ids(stop_1_id, stop_2_id)
        if best_departure is None:
            print("sorry, no connection")
        else:
            print(best_departure['routeId'], ' departures at ', best_departure['estimatedTime'])

    def departures_dialogue(self):
        print("where are you? (stop id)")
        stop_id = input()  # e.g. 2148
        stop_id_str = int(stop_id)
        print(self.dataLoader.stop_dict[stop_id_str]['stopDesc'])
        pprint(self.dataLoader.departures[stop_id])
