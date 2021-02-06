--[[
    This file is part of the NosGa Engine.
	
	NosGa Engine Copyright (c) 2019-2020 NosPo Studio

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

local global = ...

--===== shared vars =====--
local test = {
	firstRun = true,
	gos = {},
	pause = false,
	
	autoCamMove = true,
	autoCamMovesleft = true,
	autoCamSpeed = 5,
	autoCamMoveDis = 10,
	
	camSpeed = 2,
	
	goPlayer = {line = 1}, --crash prevention
}

--===== local vars =====--

--===== local functions =====--
local function print(...)
	global.log(...)
end

--===== shared functions =====--
function test.init()
	print("[test]: Start init.")
	
	--===== debug =====--
	
	--===== debug end =====--
	
	global.load({
		toLoad = {
			parents = true,
			gameObjects = true,
			textures = true,
			--animations = true,
		},
	})
	
	for i, c in pairs(global.texture) do
		if c.format == "pic" then
			global.makeImageTransparent(c, 0x00ffff)
		end
	end
	
	print("[test]: init done.")
end

function test.start()
	global.clear()
	global.debugDisplayPosY = global.resY - global.conf.consoleSizeY -1
	
	--===== debug =====--
	test.raMain = global.addRA({
		posX = 2, 
		posY = 2, 
		sizeX = global.resX / 2 -2, 
		--sizeX = 50, 
		--sizeY = global.resY - 7, 
		sizeY = 41, 
		name = "RA1", 
		drawBorders = true,
		useOwnBackBuffer = true,
	})
	test.raMain.test = true
	
	test.raSec = global.addRA({
		posX = 82, 
		posY = 2, 
		sizeX = global.resX / 2 -2, 
		--sizeX = 50, 
		--sizeY = global.resY - 7, 
		sizeY = 41, 
		name = "RA2", 
		parent = test.raMain,
		drawBorders = true,
		useOwnBackBuffer = true,
	})
	
	test.goBigRETest = test.raMain:addGO("ReTest4", {
		x = 1,
		y = 1,
		--x = 26,
		--y = 10,
		name = "BRET1",
		layer = 3,
	})
	
	test.oopTest = test.raMain:addGO("TestParent3", {
		x = 1,
		y = 1,
		--x = 26,
		--y = 10,
		name = "BRET1",
		layer = 3,
	})
	
	
	local count = 3
	local dis = 20
	for c = 1, count * dis, dis do
		table.insert(test.gos, test.raMain:addGO("ReTestStreet", {
			x = c,
			y = 10,
			name = "got_" .. tostring(c / dis - .25),
			layer = 1,
		}))
	end
	
	global.gpu.setBackground(0x0)
	global.gpu.fill(1, 1, global.resX, global.resY, " ")
	if global.conf.useDoubleBuffering then 
		global.gpu.drawChanges()
	end
	
	--===== debug end =====--
	
end

function test.update(dt)	
	--print("========================================================================================")
	
	local x, tx, y, ty = test.raMain:getFOV()
	--print(x, tx, x + test.raMain.sizeX == tx, y, ty)
	
	if test.autoCamMove then
		local x, _, y = test.raMain:getFOV()
		
		if test.autoCamMovesleft then
			test.raMain:moveCamera(test.autoCamSpeed * dt, 0)
			
			if test.raSec ~= nil then
				test.raSec:moveCamera(test.autoCamSpeed * dt, 0)
			end
			
			if x > test.autoCamMoveDis then
				test.autoCamMovesleft = false
			end
		else
			test.raMain:moveCamera(-test.autoCamSpeed * dt, 0)
			
			if test.raSec ~= nil then
				test.raSec:moveCamera(-test.autoCamSpeed * dt, 0)
			end
			
			if x < 0 then
				test.autoCamMovesleft = true
			end
		end
	end
	
	if not test.firstRun then
		--global.conf.debug.reDebug = true
		
		if test.pause then
			if global.tiConsole.status then
				local signal = {global.event.pullMultiple("key_down", "touch")}
				
				if signal[4] == global.conf.debug.debugKeys.writeInConsole then --f2
					global.tiConsole:deactivate()
				end
			else
				global.computer.pushSignal(global.event.pullMultiple("key_down", "key_up", "touch"))
			end
		end
		
		local _, x, _, y = test.raMain:getRealFOV()
		--global.db.drawRectangle(1, 1, x, y, 0x0, 0x0, " ")
		--global.db.drawChanges()
	else
		test.firstRun = false
		global.conf.debug.reDebug = false
	end
	
end

function test.draw()
	
	if false then
		global.gpu.setBackground(0x0)
		global.gpu.fill(0, 0, global.resX, global.resY, " ")
		global.db.drawChanges()
		--os.sleep(.1)
	end
end

function test.key_down(s)
	if s[4] == 28 and global.isDev then
		print("--===== EINGABE =====--")
		
		if true then
			global.realGPU.setBackground(0x000000)
			global.term.clear()
		end
		
		
	end 
	
	--print("KEY DOWN:", s[3], s[4], global.currentFrame,  "=======================================")
	
	--print(c, k)
end

function test.sUpdate()
	
end

function test.ctrl_autoCamMove_key_down(s, sname)
	test.autoCamMove = not test.autoCamMove
end
function test.ctrl_left_key_down(s, sname)
	test.goBigRETest:move(1, 0)
	--test.goStreet:move(1, 0)
end
function test.ctrl_right_key_down(s, sname)
	test.goBigRETest:move(-1, 0)
	--test.goStreet:move(-1, 0)
end
function test.ctrl_camLeft_key_down(s, sname)
	test.raMain:moveCamera(-test.camSpeed, 0)
	test.raSec:moveCamera(-test.camSpeed, 0)
end
function test.ctrl_camRight_key_down(s, sname)
	test.raMain:moveCamera(test.camSpeed, 0)
	test.raSec:moveCamera(test.camSpeed, 0)
end
function test.ctrl_camDown_key_down(s, sname)
	test.raMain:moveCamera(0, -test.camSpeed)
	test.raSec:moveCamera(0, -test.camSpeed)
end
function test.ctrl_camUp_key_down(s, sname)
	test.raMain:moveCamera(0, test.camSpeed)
	test.raSec:moveCamera(0, test.camSpeed)
end

function test.key_pressed(s)
	
	
end

function test.key_up(s)
	--print("KEY UP:", s[3], s[4], global.currentFrame, "===============================================")
end

function test.touch(s)
	--print(s[3], s[4], s[5])
	--print(test.raMain:getPos(x, y))
end

function test.ctrl_pause_key_down(s, sname)
	test.pause = not test.pause
end
--[[
function test.ctrl_camUp(s, sname)
	test.raMain:moveCamera(0, test.camSpeed)
end
function test.ctrl_camDown(s, sname)
	test.raMain:moveCamera(0, -test.camSpeed)
end
]]
function test.ctrl_test(s, sname)
	--print("TEST", global.currentFrame, sname, tostring(s[3]), tostring(s[4]))
	--print("TEST", global.currentFrame, sname, tostring(s[1]), tostring(s[2]), tostring(s[3]), tostring(s[4]), tostring(s[5]), tostring(s[6]))
end
function test.ctrl_test_key_down(s, sname)
	--print("TEST_KD", global.currentFrame, sname, s[1], s[2], s[3], s[4], s[5], s[6])
end
function test.ctrl_test_key_pressed(s, sname)
	--print("TEST_P", global.currentFrame, sname, s[1], s[2], s[3], s[4], s[5], s[6])
end
function test.ctrl_test2_key_down(s, sname)
	--print("TEST2_KD", global.currentFrame, sname, s[1], s[2], s[3], s[4], s[5], s[6])
end

function test.drag(s)
	
end

function test.drop(s)
	
end

function test.stop()
	
end

return test





