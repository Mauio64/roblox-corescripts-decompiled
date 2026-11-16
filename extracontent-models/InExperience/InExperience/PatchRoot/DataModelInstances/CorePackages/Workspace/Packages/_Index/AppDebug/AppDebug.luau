local function fn() end

local DevOnly = script:FindFirstChild("DevOnly")

local flag = false
local fn2 = nil

local function register()
	if _G.ENVIRONMENT == "PRODUCTION" or DevOnly == nil then
		return fn
	end

	if flag then
		return fn2 or fn
	end

	flag = true

	local TagAnnotationSection = require(DevOnly.TagAnnotation.TagAnnotationSection)
	local v = { TagAnnotationSection }

	fn2 = function()
		for _, v2 in v do
			v2()
		end

		flag = false
		fn2 = nil
	end

	return fn2
end

return {
	["jest.config"] = script["jest.config"],
	dumpInstanceTree = require(script.dumpInstanceTree),
	idFor = require(script.idFor),
	littleTraceback = require(script.littleTraceback),
	logTreeGraphviz = require(script.logTreeGraphviz),
	LogTree = require(script.LogTree),
	register = register
}
