local global = ...

ReTest = {}
ReTest.__index = ReTest

function ReTest.init(this) --will calles when the gameObject become loaded/reloaded.
	--global.log("ReTest: init")
end

function ReTest.new(args)
	args = args or {}
	args.sizeX = 5
	args.sizeY = 5
	args.components = {
		{"Sprite", texture = "human"},
	}
	
	--===== default stuff =====--
	local this = global.core.GameObject.new(args)
	this = setmetatable(this, ReTest)
	
	--===== init =====--
	
	--===== global functions =====--
	
	--===== default functions =====--
	this.start = function(this, t)
		
	end	
	
	this.update = function(this, dt, ra) --will called on every game tick.
		
	end
	
	return this
end

return ReTest