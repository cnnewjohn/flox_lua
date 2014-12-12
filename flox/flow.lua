local API = require "flox.api"
local _M = {}
local mt = {__index = _M}

--[[
-- flow configs
--]]
local configs = {}

--[[
flow config: {
    id = 'flow_id',
    entry = 'entity_id',
    entity = {
        entity_id = {
            type = 'process', -- process, decision
            next = 'entity_id_2',
            api = 'api_1',
            argv = {},
        },
        entity_id_2 = {
            type = 'decision',
            decision = {
                1 = {
                    condition = '1 = 1',
                    next = 'entity_id',
                },
            },
        },
    },
}
--]]
--[[
-- flow config loader function
--]]
local loader

--[[
-- load flow config by flow id
--]]
local function load_config(id)
    
    config = configs[id]
    
    if not config and loader then
        config = loader(id)
        valid_config(config)
    end
    
    return config
end

--[[
-- valid flow config
--]]
local function valid_config(config)

    if type(config) ~= 'table' then
        error('config must be table')
    end

    if not config.entry then
        error('config.entry is nil')
    end

    if type(config.entity) ~= 'table' then
        error('config.entity must be table')
    end

    if not config.entity[config.entry] then
        error('config.entry not exists in entity')
    end

end

--[[
-- execute entity
--]]
local function execute_entity_process(entity)
    local api = API:new(entity.api)
    api:call(entity.argv)
    return entity.next
end

local function execute_entity_decision(entity)
    local f
    for k, decision in pairs(entity.decision) do
        f = loadstring('return ' .. decision.condition)
        if f() then
            return decision.next
        end
    end
end

local function execute_entity(entity)
    if entity.type == 'process' then
        return execute_entity_process(entity)
    elseif entity.type == 'decision' then
        return execute_entity_decision(entity)
    end
end


--[[
-- create new flow instance
--]]
function _M:new(id, config)
    
    if config then
        valid_config(config)
        configs[id] = config
    else
        config = load_config(id)
    end

    self = {
        _config = config
    }

    return setmetatable(self, mt)

end

function _M:set_loader(flow_loader)
    loader = flow_loader

end

--[[
-- start flow
--]]
function _M:start()
    local entity_id = self._config.entry
    
    while self._config.entity[entity_id] do
        entity_id = execute_entity(self._config.entity[entity_id])
    end
end


return _M
