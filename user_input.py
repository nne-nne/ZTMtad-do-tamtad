from DataLoader import DataLoader
from pprint import pprint


class UserInput:
    def __init__(self, data_loader: DataLoader):
        self.dataLoader = data_loader

    def are_stops_connected_dialogue(self):
        print("where are you? (stop id)")
        stop_1_id = int(input())  # e.g. 2148
        print("where do you want to be? (stop id)")
        stop_2_id = int(input())    # e.g. 2149
        print("your route:")
        print(self.dataLoader.stop_dict[stop_1_id]['stopDesc'], '->', self.dataLoader.stop_dict[stop_2_id]['stopDesc'])

        # TODO calculate if stops are connected
        # TODO print answer

    def departures_dialogue(self):
        print("where are you? (stop id)")
        stop_id = input()  # e.g. 2148
        stop_id_str = int(stop_id)
        print(self.dataLoader.stop_dict[stop_id_str]['stopDesc'])
        pprint(self.dataLoader.departures[stop_id])
