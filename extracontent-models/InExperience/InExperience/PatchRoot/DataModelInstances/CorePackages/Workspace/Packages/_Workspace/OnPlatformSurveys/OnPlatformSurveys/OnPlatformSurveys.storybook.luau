local OnPlatformSurveys = script:FindFirstAncestor("OnPlatformSurveys")
local OnPlatformSurveysParent = OnPlatformSurveys.Parent
local React = require(OnPlatformSurveysParent.React)
local ReactRoblox = require(OnPlatformSurveysParent.Dev.ReactRoblox)
local Foundation = require(OnPlatformSurveysParent.Foundation)
local FoundationProvider = Foundation.FoundationProvider
local Theme = Foundation.Enums.Theme
local Device = Foundation.Enums.Device
local MockProviders = require(OnPlatformSurveys.MockProviders)
local t1 = {
	Dark = Theme.Dark,
	Light = Theme.Light
}

local function union(t2: {[any]: any}, t3: {[any]: any}?) -- line: 26
	local v14 = table.clone(t2)

	if t3 then
		for v15, v16 in t3 do
			v14[v15] = v16
		end
	end

	return v14
end

return {
	roact = React,
	reactRoblox = ReactRoblox,
	mapStory = function(p1) -- line: 39
		-- upvalues: React (copy), MockProviders (copy), FoundationProvider (copy), t1 (copy), Theme (copy), Device (copy)
		return function(p2) -- line: 40
			-- upvalues: React (copy), MockProviders (copy), FoundationProvider (copy), t1 (copy), Theme (copy), Device (copy), p1 (copy)
			local v19 = p2.definition and p2.definition.props or {}
			local v20 = table.clone(p2)

			if v19 then
				for v21, v22 in v19 do
					v20[v21] = v22
				end
			end

			return React.createElement(MockProviders, {}, {
				FoundationProvider = React.createElement(FoundationProvider, {
					theme = t1[p2.theme] or Theme.Dark,
					device = Device[p2.platform] or Device.Phone,
					preferences = p2.settings,
					overlayGui = p2.focus
				}, {
					story = React.createElement(p1, v20)
				})
			})
		end
	end,
	storyRoots = { OnPlatformSurveys }
}
