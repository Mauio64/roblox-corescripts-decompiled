local Parent = script:FindFirstAncestor("InExperienceLocales").Parent
local LocalizationContext = require(Parent.Localization).LocalizationContext
local Signal = require(Parent.AppCommonLib).Signal
local Locales = game:GetService("CoreGui").RobloxGui.Modules.Common:FindFirstChild("Locales")

local function loadTables(s1: string) -- line: 31
	-- upvalues: Locales (copy), LocalizationContext (copy)
	if not Locales then
		error("ERROR: Locales tables does not exist")
	end

	local v8 = LocalizationContext.getRelevantLanguages(s1)
	local t1 = {}

	for _, v in ipairs(v8) do
		local v2 = Locales:FindFirstChild(v)

		if v2 then
			t1[v] = require(v2)
		end
	end

	return t1
end

local t2 = {}

t2.__index = t2

function t2.new(s2: string) -- line: 50
	-- upvalues: Signal (copy), LocalizationContext (copy), loadTables (copy), t2 (copy)
	local t3 = {
		locale = s2,
		changed = Signal.new(),
		localizationContext = LocalizationContext.new((loadTables(s2)))
	}

	setmetatable(t3, t2)

	return t3
end
function t2.SetLocale(t4: {[any]: any}, s3: string) -- line: 60
	-- upvalues: loadTables (copy)
	t4.locale = s3

	local v17 = loadTables(s3)

	t4.localizationContext:addTranslations(v17)
	t4.changed:fire()
end
function t2.GetLocale(p1) -- line: 67
	return p1.locale
end
function t2.Format(t5: {[any]: any}, s4: string, t6: {[any]: any}?) -- line: 71
	if not s4 then
		error("ERROR: NO STRING FOR KEY")
	end

	return (t5.localizationContext:getString(t5.locale, s4, t6))
end

return t2
