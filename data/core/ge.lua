--[[
    This file is part of the NosGa Engine.
	
	NosGa Engine Copyright (c) 2019 NosPo Studio

    The NosGa Engine is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    The NosGa Engine is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with the NosGa Engine.  If not, see <https://www.gnu.org/licenses/>.
]]

--GameEngine
local global = ...
local ge = {
	isUpdated = {},
	signalQueue = {},
}

--===== local vars =====--

--===== local functions =====--
local function print(...)
	if global.conf.debug.geDebug then
		global.debug(...)
	end
end

local function isInsideArea(ra, go, expansion)
	local x, y = go:getPos()
	local sx, sy = go.attributes.sizeX, go.attributes.sizeY
	local fromX, toX, fromY, toY = ra:getFOV()
	local expansion = expansion or {0, 0, 0, 0}
	
	if x +sx > fromX -expansion[1] and x < toX +expansion[2] and y +sy > fromY -expansion[3] and y < toY +expansion[4] then
		return true
	end
	
	return false
end

local function calculateFrame(renderArea)
	local expansion = renderArea.narrowUpdateExpansion
	
	if global.conf.debug.narrowUpdateExpansion ~= false then
		renderArea.updateAnything = false
		local fromX, toX, fromY, toY = renderArea:getFOV()
		
		for i, go in pairs(renderArea.gameObjects) do
			local l = go.attributes.layer
			
			if renderArea.layerBlacklist[l] ~= true and 
				isInsideArea(renderArea, go, global.conf.debug.narrowUpdateExpansion) and 
				renderArea.toUpdate[go] == nil 
			then 
				renderArea.toUpdate[go] = true
			end
		end
	else
		renderArea.updateAnything = true
	end
end

local function updateFrame(renderArea, dt)
	local toUpdate = renderArea.toUpdate
	
	if renderArea.updateAnything then
		toUpdate = renderArea.gameObjects
	end
	
	for go in pairs(toUpdate) do
		if not ge.isUpdated[go] then
			for i, s in pairs(ge.signalQueue) do
				--print(s[1], go[s[1]], global.currentFrame)
				
				global.run(go[s.name], s.signal, s.name)
			end
			
			go:pUpdate(global.gameObjects, dt, renderArea)
			ge.isUpdated[go] = true
		end
	end
	
	renderArea.toUpdate = {}
end

--===== global functions =====--
function ge.init()
	
end

function ge.update(dt)
	dt = dt or global.dt
	
	for i, ra in pairs(global.renderAreas) do
		if not ra.silent then
			calculateFrame(ra)
			updateFrame(ra, dt)
		end
	end
	
	ge.isUpdated = {}
	ge.signalQueue = {}
end

function ge.insertSignal(s, signalName)
	
	--[[
	local t = s
	
	if signalName ~= nil then
		t = {signalName}
		for i, c in pairs(s) do
			if i > 1 then
				t[i] = c
			end
		end
		
		--ge.signalQueue[#ge.signalQueue][1] = signalName
	end
	]]
	--print(signalName)
	table.insert(ge.signalQueue, {name = signalName, signal = s})
	
	--global.log(global.currentFrame, signalName)
	--global.slog(ge.signalQueue)
	
end

--===== init =====--

return ge