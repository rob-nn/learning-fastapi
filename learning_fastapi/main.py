from fastapi import FastAPI
from enum import Enum

app = FastAPI()

@app.get('/')
async def root():
    return {"message": "hello world"}

    
@app.post("/")
async def post():
    return {"message": "hello from post route"}

@app.put("/")
async def put():
    return {"message": "hello from put route"}

@app.get('/item/{item_id}')
async def get_item(item_id: int):
    return {'item_id': item_id}

@app.get('/users')
async def get_users():
    return {'message': "list users route"}

@app.get('/users/{user_id}')
async def get_user(user_id: int):
    return {'user_id': user_id}


@app.get('/user/me')
async def get_current_user():
    return {'message': "This is the current user"}

    
class FoodEnum(str, Enum):
    fruits = "fruits"
    vegetable = "vegetable"
    dairy = "dairy"

@app.get("/food/{food_name}")
async def get_food(food_name: FoodEnum):
    if food_name == FoodEnum.vegetable:
        return {"food_name": food_name, "message": "you are healthy"}
    if food_name.value == FoodEnum.fruits:
        return {"food_name": food_name, "message": "you are still healthy, byt like sweet things"}

    return {"food_name": food_name, "message": "I like chocolate milk"}

fake_item_db = [{"item_name": "foo"}, {"item_name": "Bar"}, {"intem_name": "Baz"}]

@app.get("/items")
async def list_items(skip: int = 0, limit: int = 10):
    return fake_item_db [skip: skip + limit]

@app.get("/items/{item_id}") 
async def get_item(item_id: str, requested_param: str, q: str | None = None, short: bool = True) -> dict:
    item = {"item_id": item_id, "requested_param": requested_param}
    if q:
        item.update({"q": q})
    if not short:
        item.update({"description": "Helllooowrerwe it's my description"})
    return item
