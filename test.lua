FLOX = require "flox"
local FLOW = require "flox.flow" 
local API = require "flox.api"

API:new('api_1', {
    expr = 'print("from api")'
})

flow1 = FLOW:new('flow1',{
    id = 'flow1',
    entity = {
        [1] = {
            type = 'process',
            api = 'api_1',
        }, 
    },
    entry = 1,

})

flox1 = FLOX:new()
flox1:load_flow('flow1')
flox1:start()

--[[
flow2 = FLOW:new('flow2', {
    id = 'flow2'
})

flox1 = FLOX:new()
flox1:load_flow('flow1')

flox2 = FLOX:new()
flox2:load_flow('flow21')

flox2:start()
flox1:start()
--]]
