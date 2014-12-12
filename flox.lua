--[[
-- Flox, a Flow Engine
--]]
local _M = {
    _VERSION = '0.0.1',
}
local mt = {
    __index = _M
}
local FLOW = require "flox.flow"

--[[
-- create new flox instance
--]]
function _M:new()
    return setmetatable({}, mt)
end

--[[
-- load flow config
--
-- @param string flow_id, flow id
--
--]]
function _M:load_flow(flow_id)
    self._flow_id = flow_id
    self._flow = FLOW:new(flow_id)
end

--[[
-- get flow instance
--
-- @param string flow_id
--]]
function _M:get_flow(flow_id)
    return self._flow
end

--[[
-- start flox instance
--]]
function _M:start()
    if self._flow then
        self._flow:start()
    end
end


return _M
