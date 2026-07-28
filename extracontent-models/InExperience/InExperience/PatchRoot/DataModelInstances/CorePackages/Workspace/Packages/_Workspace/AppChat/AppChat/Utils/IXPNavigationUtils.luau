local IXPService = game:GetService("IXPService")
local Parent = script:FindFirstAncestor("AppChat").Parent
local React = require(Parent.React)
local RoactNavigation = require(Parent.RoactNavigation)
local useNavigation = require(Parent.Navigation).useNavigation
local t1 = {
	ExposureKind = {
		FlagLinked = "FlagLinked",
		BrowserTracker = "BrowserTracker",
		UserLayer = "UserLayer",
		Creator = "Creator"
	}
}
local t2 = {
	remove = function() -- line: 102
	end
}
local t3 = {
	[t1.ExposureKind.FlagLinked] = "LogFlagLinkedUserLayerExposure",
	[t1.ExposureKind.BrowserTracker] = "LogBrowserTrackerLayerExposure",
	[t1.ExposureKind.UserLayer] = "LogUserLayerExposure",
	[t1.ExposureKind.Creator] = "LogCreatorLayerExposure"
}
local u9 = IXPService

local function normalizeLayers(p1) -- line: 119
	if type(p1) == "string" then
		return { p1 }
	end

	return p1
end
local function isAnyFlagEnabled(p2) -- line: 128
	if p2 == nil then
		return true
	end

	if type(p2) == "boolean" then
		return p2
	end

	for _, v16 in p2 do
		if v16 then
			return true
		end
	end

	return false
end
local function logExposure(t4: {[any]: any}, p3) -- line: 146
	-- upvalues: t1 (copy), t3 (copy), u9 (ref)
	local v19 = p3 or t1.ExposureKind.FlagLinked

	for _, v21 in t4 do
		local v22 = t3[v19]
		local v23 = if not v22 then nil else u9[v22]

		if v23 then
			v23(u9, v21)
		end
	end
end

function t1.createExposureHandler(p4, t5: {[any]: any}?) -- line: 167
	-- upvalues: logExposure (copy)
	local v26 = if type(p4) ~= "string" then p4 else { p4 }
	local v27 = if not t5 then nil else t5.flags
	local v28 = if not t5 then nil else t5.kind

	return function() -- line: 175
		-- upvalues: v27 (copy), logExposure (copy), v26 (copy), v28 (copy)
		local v42 = v27
		local g45

		if v42 == nil then
			v42 = true
		elseif type(v42) == "boolean" then
		else
			g45 = nil

			for _, v44 in v42 do
				if v44 then
					v42 = true
					g45 = true
				end

				if g45 then
					break
				end
			end

			if not g45 then
				v42 = false
			end
		end

		g45 = false

		if v42 then
			logExposure(v26, v28)
		end
	end
end
function t1.useExposureOnFocus(p5, t6: {[any]: any}?) -- line: 193
	-- upvalues: useNavigation (copy), React (copy), t1 (copy), RoactNavigation (copy)
	local v31 = useNavigation()
	local v32 = if not t6 then nil else t6.flags
	local v33 = if not t6 then nil else t6.kind

	React.useEffect(function() -- line: 198
		-- upvalues: v31 (copy), v32 (copy), t1 (copy), p5 (copy), v33 (copy), RoactNavigation (copy)
		if v31 then
			local v46 = v32
			local g49

			if v46 == nil then
				v46 = true
			elseif type(v46) == "boolean" then
			else
				g49 = nil

				for _, v48 in v46 do
					if v48 then
						v46 = true
						g49 = true
					end

					if g49 then
						break
					end
				end

				if not g49 then
					v46 = false
				end
			end

			g49 = false

			if v46 then
				local v50 = t1.createExposureHandler(p5, {
					flags = v32,
					kind = v33
				})
				local v51 = v31.addListener(RoactNavigation.Events.WillFocus, v50)

				if v31.isFocused and v31.isFocused() then
					v50()
				end

				return function() -- line: 213
					-- upvalues: v51 (copy)
					v51.remove()
				end
			end
		end

		return nil
	end, {
		v31,
		p5,
		v32,
		v33
	})
end
function t1.registerExposureOnFocus(t7: {[any]: any}?, p6, t8: {[any]: any}?) -- line: 231
	-- upvalues: t2 (copy), RoactNavigation (copy), t1 (copy)
	if not t7 then
		return t2
	end

	local v37 = if not t8 then nil else t8.flags
	local g40

	if v37 == nil then
		v37 = true
	elseif type(v37) == "boolean" then
	else
		g40 = nil

		for _, v39 in v37 do
			if v39 then
				v37 = true
				g40 = true
			end

			if g40 then
				break
			end
		end

		if not g40 then
			v37 = false
		end
	end

	g40 = false

	if not v37 then
		return t2
	end

	return t7.addListener(RoactNavigation.Events.WillFocus, t1.createExposureHandler(p6, t8))
end
function t1.setMocksForTesting(p7) -- line: 251
	-- upvalues: u9 (ref)
	u9 = p7 or u9
end
function t1.restoreDefaultsAfterTesting() -- line: 255
	-- upvalues: u9 (ref), IXPService (copy)
	u9 = IXPService
end

return t1
