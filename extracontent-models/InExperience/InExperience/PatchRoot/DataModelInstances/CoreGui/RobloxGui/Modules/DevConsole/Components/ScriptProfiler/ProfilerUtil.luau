require(script.Parent.ProfilerDataFormatV2)

local ProfilerUtil = {
	getDurations = function(p, p2)
		if p2 > 0 then
			local node = p.Nodes[p2]
			assert(node ~= nil)

			return node.TotalDuration, node.Duration
		else
			local total = 0

			for _, category in p.Categories do
				total += p.Nodes[category.NodeId].TotalDuration
			end

			return total, 0
		end
	end,
	getName = function(_, p)
		return p and p.Name
	end,
	getSourceName = function(_, p)
		return p and p.Source
	end,
	getLine = function(_, p)
		return p and p.Line
	end,
	getNativeFlag = function(_, p)
		return p and p.IsNative or false
	end,
	getPluginFlag = function(_, p)
		return p and p.IsPlugin or false
	end,
	standardizeChildren = function(_, p)
		return p and p.Children
	end,
	formatSessionLength = function(p: number?)
		if not p then
			return nil
		end

		local v = p / 3600000
		local v2 = p / 60000 % 60
		local v3 = p / 1000 % 60
		local v4 = p % 1000

		return string.format("%02i:%02i:%02i.%04i", v, v2, v3, v4)
	end,
	formatTimer = function(p: number?)
		if p == nil then
			return ""
		elseif p == 0 then
			return ""
		end

		if p >= 60 then
			return string.format("%dm", p / 60)
		end

		return string.format("%ds", p)
	end,
	formatFrequency = function(p)
		if p < 1000 then
			return tostring(p) .. " Hz"
		end

		return tostring(p / 1000) .. " KHz"
	end
}

function ProfilerUtil.getSourceLocationString(p, p2, p3: string)
	local sourceLocationString = ProfilerUtil.getSourceName(p, p2)

	if sourceLocationString then
		if #sourceLocationString == 0 then
			sourceLocationString = p3
		end
	else
		sourceLocationString = p3
	end

	local line = ProfilerUtil.getLine(p, p2)

	if line and line >= 1 then
		sourceLocationString = string.format("%s:%s", sourceLocationString, (tostring(line)))
	end

	return sourceLocationString
end

return ProfilerUtil
