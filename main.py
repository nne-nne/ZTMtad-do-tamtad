import webservice
import user_input
import path_finder
from DataLoader import DataLoader
from pprint import pprint

data_loader = DataLoader().full_prepare()
webService = webservice.Webservice()
path_finder = path_finder.PathFinder(data_loader)
user_input = user_input.UserInput(data_loader, path_finder)

if __name__ == '__main__':
    while input() != 'quit':
        pass
