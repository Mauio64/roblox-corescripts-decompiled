local Parent = script:FindFirstAncestor("AvatarExperienceAnalytics").Parent
local React = require(Parent.React)

local function v3(p1) -- line: 6
	-- upvalues: React (copy)
	return React.createElement("Frame", {}, p1.children)
end
local function createLocalization() -- line: 10
	return {
		Format = function(_, s1: string) -- line: 12
			return s1 .. "-translated"
		end,
		GetLocale = function() -- line: 15
			return "locale"
		end
	}
end
local function makeTestRoot(t1: {[any]: any}?) -- line: 21
	-- upvalues: createLocalization (copy), React (copy), v3 (copy)
	local v8 = (t1 or {
		localization = nil
	}).localization or createLocalization()

	return function(p3) -- line: 25
		-- upvalues: React (copy), v3 (copy), v8 (copy)
		return React.createElement(v3, {
			localization = v8
		}, {
			TestSubject = p3.children
		})
	end
end

return makeTestRoot
