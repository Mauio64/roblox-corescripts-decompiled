require(script.Parent.ProfilerDataFormatV2)

local t1 = {
	getDurations = function(p1, p2) -- line: 11
		if p2 > 0 then
			local v4 = p1.Nodes[p2]

			assert(v4 ~= nil)

			return v4.TotalDuration, v4.Duration
		end

		local n1 = 0

		for _, v7 in p1.Categories do
			n1 += p1.Nodes[v7.NodeId].TotalDuration
		end

		return n1, 0
	end,
	getName = function(_, p4) -- line: 31
		return p4 and p4.Name
	end,
	getSourceName = function(_, p6) -- line: 35
		return p6 and p6.Source
	end,
	getLine = function(_, p8) -- line: 39
		return p8 and p8.Line
	end,
	getNativeFlag = function(_, p10) -- line: 43
		return not not p10 and (p10.IsNative or false)
	end,
	getPluginFlag = function(_, p12) -- line: 47
		return not not p12 and (p12.IsPlugin or false)
	end,
	standardizeChildren = function(_, p14) -- line: 51
		return p14 and p14.Children
	end,
	formatSessionLength = function(n2: number?) -- line: 55
		if n2 then
			local v21 = n2 / 3600000
			local v22 = n2 / 60000 % 60
			local v23 = n2 / 1000 % 60
			local v24 = n2 % 1000

			return string.format("%02i:%02i:%02i.%04i", v21, v22, v23, v24)
		end

		return nil
	end,
	formatTimer = function(n3: number?) -- line: 68
		if n3 ~= nil then
			if n3 == 0 then
				return ""
			end

			if n3 >= 60 then
				return string.format("%dm", n3 / 60)
			end

			return string.format("%ds", n3)
		end

		return ""
	end,
	formatFrequency = function(p15) -- line: 82
		if p15 < 1000 then
			return tostring(p15) .. " Hz"
		end

		return tostring(p15 / 1000) .. " KHz"
	end
}

function t1.getSourceLocationString(p16, p17, s1: string) -- line: 92
	-- upvalues: t1 (copy)
	local v30 = t1.getSourceName(p16, p17)
	local v31 = if not not v30 and #v30 ~= 0 then v30 else s1
	local v32 = t1.getLine(p16, p17)

	if v32 and v32 >= 1 then
		v31 = string.format("%s:%s", v31, (tostring(v32)))
	end

	return v31
end

return t1
