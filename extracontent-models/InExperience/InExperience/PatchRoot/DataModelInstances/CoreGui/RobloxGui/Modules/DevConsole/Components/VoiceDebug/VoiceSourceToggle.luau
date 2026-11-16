local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Constants = require(script.Parent.Parent.Parent.Constants)
local VoiceDebugSource = require(script.Parent.VoiceDebugSource)

local v = {
	{ source = VoiceDebugSource.InExperience, label = "In-experience" },
	{ source = VoiceDebugSource.Party, label = "Party voice" }
}

local udim = UDim.new(0, 8)

local function resolveActivatedSource(source: string, source2: string) -- 1 equivalent call inferred from this helper
	return if source ~= source2 then source2 else nil
end

local function Segment(p, flag: boolean, k: number, fn)
	local text = flag and Constants.Color.Text or Constants.Color.BorderGray

	return Roact.createElement("TextButton", {
		Text = p.label,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 0, 20),
		LayoutOrder = k,
		Font = Constants.Font.MainWindow,
		TextSize = Constants.DefaultFontSize.MainWindow + -2,
		TextColor3 = text,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		[Roact.Event.Activated] = fn
	}, {
		Padding = Roact.createElement("UIPadding", { PaddingLeft = udim, PaddingRight = udim }),
		Underline = flag and Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0.5, 1),
			Position = UDim2.new(0.5, 0, 1, 0),
			Size = UDim2.new(1, -8, 0, 2),
			BackgroundColor3 = Constants.Color.SelectedBlue,
			BorderSizePixel = 0
		}) or nil
	})
end

local function VoiceSourceToggle(props)
	local v2 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			SortOrder = Enum.SortOrder.LayoutOrder
		})
	}

	for k, v3 in v do
		v2[v3.source] = Segment(v3, props.source == v3.source, k, function()
			local activatedSource = resolveActivatedSource(props.source, v3.source) -- inferred equivalent call

			if activatedSource then
				props.onSourceChanged(activatedSource)
			end
		end)
	end

	return Roact.createElement(
		"Frame",
		{
			AutomaticSize = Enum.AutomaticSize.X,
			Size = UDim2.new(0, 0, 0, 20),
			BackgroundTransparency = 1,
			LayoutOrder = props.layoutOrder
		},
		v2
	)
end

return VoiceSourceToggle
