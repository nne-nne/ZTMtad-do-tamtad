from DataLoader import DataLoader


class UserInput:
    def __init__(self, data_loader: DataLoader):
        self.dataLoader = data_loader

    def areStopsConnectedDialogue(self):
        print("provide stop id")
        stopId = input()
        print(stopId)


