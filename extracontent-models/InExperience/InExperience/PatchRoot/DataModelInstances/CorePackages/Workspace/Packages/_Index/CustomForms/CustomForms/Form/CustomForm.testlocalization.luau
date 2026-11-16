local v = { ["Feature.CustomForms.Label.Percent"] = "{number}%" }
local Testlocalization = {}

function Testlocalization.Format(_, p: string, p2)
	local v2 = v[p] or p

	return (string.gsub(v2, "{(%w+)}", function(p3: string)
		if p2 and p2[p3] ~= nil then
			return (tostring(p2[p3]))
		end

		return "{" .. p3 .. "}"
	end))
end

function Testlocalization.GetLocale(): string
	return "en-us"
end

return Testlocalization
