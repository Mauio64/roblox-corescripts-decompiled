local Squads = script:FindFirstAncestor("Squads")

local parent = Squads.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

UIBlox.init(require(parent.Dev.RobloxAppUIBloxConfig))

local SocialTestHelpers = require(parent.Dev.SocialTestHelpers)
local mockLocale = SocialTestHelpers.StoryHelpers.mockLocale

local dependencies = require(Squads.dependencies)
local cryo = dependencies.Cryo
local foundation = dependencies.Foundation
local roact = dependencies.Roact

local AppStyleProvider = UIBlox.App.Style.AppStyleProvider

roact.setGlobalConfig({ propValidation = true, elementTracing = true })

local v = {
	Default = { themeName = "Light", fontName = "Gotham" },
	Light = { themeName = "Light", fontName = "Gotham" },
	Dark = { themeName = "Dark", fontName = "Gotham" }
}

local v2 = { language = "en-us" }

local function useCreateOverlay(p)
	local ref = React.useRef(Instance.new("Frame"))

	if ref.current.Parent ~= p.focus then
		ref.current.Parent = p.focus
	end

	React.useEffect(function()
		ref.current.Size = UDim2.fromScale(1, 1)
		ref.current.BackgroundTransparency = 1

		return function()
			ref.current:Destroy()
		end
	end, {})

	return ref.current
end

local Storybook = {}
Storybook.name = "Squads"
Storybook.storyRoot = Squads
Storybook.roact = roact

function Storybook.mapDefinition(p)
	local joined = cryo.Dictionary.join(v2, p.controls or {})
	return cryo.Dictionary.join(p, { controls = joined })
end

function Storybook.mapStory(p)
	return function(p2)
		local overlayGui = useCreateOverlay(p2)

		local style = p2 and v[p2.theme] or v.Default
		return roact.createElement(
			"Frame",
			{
				AutomaticSize = Enum.AutomaticSize.XY,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1
			},
			{ roact.createElement(
					foundation.FoundationProvider,
					{ device = "Desktop", colorMode = style.themeName, overlayGui = overlayGui },
					{ roact.createElement(AppStyleProvider, { style = style }, {
							Child = mockLocale(p, p2)
						}) }
				) }
		)
	end
end

return Storybook
