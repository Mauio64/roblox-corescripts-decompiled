local function v1() -- line: 26
end

local DevOnly = script:FindFirstChild("DevOnly")
local u3 = false
local u4 = nil

return {
	["jest.config"] = script["jest.config"],
	dumpInstanceTree = require(script.dumpInstanceTree),
	idFor = require(script.idFor),
	littleTraceback = require(script.littleTraceback),
	logTreeGraphviz = require(script.logTreeGraphviz),
	LogTree = require(script.LogTree),
	register = function() -- line: 33
		-- upvalues: DevOnly (copy), v1 (copy), u3 (ref), u4 (ref)
		if DevOnly == nil then
			return v1
		end

		if u3 then
			return u4 or v1
		end

		u3 = true

		local t1 = { (require(DevOnly.TagAnnotation.TagAnnotationSection)) }

		function u4() -- line: 47
			-- upvalues: t1 (copy), u3 (ref), u4 (ref)
			for _, v7 in t1 do
				v7()
			end

			u3 = false
			u4 = nil
		end

		return u4
	end
}
