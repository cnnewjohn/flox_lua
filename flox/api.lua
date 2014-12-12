local _M = {}
local mt = {__index = _M}

local apis = {}
local configs = {}
--[[
api config: {
    param = {},
    expr = '',
}
--]]
local loader

local function load_config(id)
    config = configs[id]
    if not config and loader then
        config = loader(id)
        valid_config(config)
    end
    return config
end

local function valid_config(config)

end


function _M:new(id, config)
    if apis[id] then
        return apis[id]
    end

    if config then
        valid_config(config)
        configs[id] = config
    else
        config = load_config(id)
    end

    self = {
        _config = config,
        _proto = loadstring(config.expr),
    }

    apis[id] = setmetatable(self, mt)
    return apis[id]
end

function _M:set_loader(api_loader)
    loader = api_loader
end

function _M:call(argv)
    if type(argv) == 'table' then
        argv = unpack(argv)
    end
    return self._proto(argv)
end

return _M
