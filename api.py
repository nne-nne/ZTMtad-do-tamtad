from typing import Union
from fastapi import FastAPI

import webservice
import user_input
import path_finder
from DataLoader import DataLoader
from pprint import pprint

from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel


class Item(BaseModel):
    stop1_str: str
    stop2_str: str


app = FastAPI()

origins = [
    "*",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

data_loader = DataLoader().full_prepare()
webService = webservice.Webservice()
path_finder = path_finder.PathFinder(data_loader)
user_input = user_input.UserInput(data_loader, path_finder)


@app.get("/")
def read_root():
    print("home request")
    return {"Hello": "World"}


@app.get("/items/{item_id}")
async def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}


@app.get("/departure/{stop1_id}/{stop2_id}")
async def read_item(stop1_id: int, stop2_id: int):
    return path_finder.first_departure_from_stop_ids(stop1_id, stop2_id)


@app.post("/paths/")
async def create_item(item: Item):
    return path_finder.stopnames_user_request_handler(item.stop1_str, item.stop2_str)



