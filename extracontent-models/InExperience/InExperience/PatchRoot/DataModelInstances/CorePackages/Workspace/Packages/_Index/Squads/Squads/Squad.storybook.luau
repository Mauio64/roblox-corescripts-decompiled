local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local React = require(SquadsParent.React)
local UIBlox = require(SquadsParent.UIBlox)

UIBlox.init(require(SquadsParent.Dev.RobloxAppUIBloxConfig))

local mockLocale = require(SquadsParent.Dev.SocialTestHelpers).StoryHelpers.mockLocale
local dependencies = require(Squads.dependencies)
local Cryo = dependencies.Cryo
local Foundation = dependencies.Foundation
local Roact = dependencies.Roact
local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

Roact.setGlobalConfig({
	propValidation = true,
	elementTracing = true
})

local t1 = {
	Default = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Light = {
		themeName = "Light",
		fontName = "Gotham"
	},
	Dark = {
		themeName = "Dark",
		fontName = "Gotham"
	}
}
local t2 = {
	language = "en-us"
}

local function useCreateOverlay(t3: {[any]: any}) -- line: 44
	-- upvalues: React (copy)
	local v15 = React.useRef(Instance.new("Frame"))

	if v15.current.Parent ~= t3.focus then
		v15.current.Parent = t3.focus
	end

	React.useEffect(function() -- line: 52
		-- upvalues: v15 (copy)
		v15.current.Size = UDim2.fromScale(1, 1)
		v15.current.BackgroundTransparency = 1

		return function() -- line: 56
			-- upvalues: v15 (copy)
			v15.current:Destroy()
		end
	end, {})

	return v15.current
end

return {
	name = "Squads",
	storyRoot = Squads,
	roact = Roact,
	mapDefinition = function(p1) -- line: 68
		-- upvalues: Cryo (copy), t2 (copy)
		local v17 = Cryo.Dictionary.join(t2, p1.controls or {})

		return Cryo.Dictionary.join(p1, {
			controls = v17
		})
	end,
	mapStory = function(p2) -- line: 72
		-- upvalues: useCreateOverlay (copy), t1 (copy), Roact (copy), Foundation (copy), AppStyleProvider (copy), mockLocale (copy)
		return function(p3) -- line: 73
			-- upvalues: useCreateOverlay (copy), t1 (copy), Roact (copy), Foundation (copy), AppStyleProvider (copy), mockLocale (copy), p2 (copy)
			local v20 = useCreateOverlay(p3)
			local v21 = p3 and t1[p3.theme] or t1.Default

			return Roact.createElement("Frame", {
				BackgroundTransparency = 1,
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(1, 0, 1, 0)
			}, { Roact.createElement(Foundation.FoundationProvider, {
				device = "Desktop",
				theme = v21.themeName,
				overlayGui = v20
			}, { Roact.createElement(AppStyleProvider, {
				style = v21
			}, {
				Child = mockLocale(p2, p3)
			}) }) })
		end
	end
}
