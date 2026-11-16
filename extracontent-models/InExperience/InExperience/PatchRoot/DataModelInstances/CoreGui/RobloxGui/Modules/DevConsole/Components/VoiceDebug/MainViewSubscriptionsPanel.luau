local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)

local Constants = require(script.Parent.Parent.Parent.Constants)

local CollapsibleSection = require(script.Parent.CollapsibleSection)

require(script.Parent.VoiceDebugData)

local udim = UDim.new(0.13, 0)
local udim2 = UDim.new(0.11, 0)
local udim3 = UDim.new(0.11, 0)
local udim4 = UDim.new(0.12, 0)
local udim5 = UDim.new(0.11, 0)
local udim6 = UDim.new(0.14, 0)
local udim7 = UDim.new(0.1, 0)
local udim8 = UDim.new(0.09, 0)
local udim9 = UDim.new(0.09, 0)

local v = udim + udim2
local v2 = v + udim3
local v3 = v2 + udim4
local v4 = v3 + udim5
local v5 = v4 + udim6
local v6 = v5 + udim7
local v7 = v6 + udim8

local TextBoxGray = Constants.Color.TextBoxGray

local function formatHexSsrc(audioSsrc: number?) -- 1 equivalent call inferred from this helper
	if type(audioSsrc) == "number" and audioSsrc == audioSsrc and audioSsrc % 1 == 0 then
		return string.format("0x%08X", audioSsrc)
	end

	return "—"
end

local function formatOrDash(p) -- 4 equivalent calls inferred from this helper
	if p == nil or p == "" then
		return "—"
	end

	return (tostring(p))
end

local function formatBool(flag: boolean?): string -- 3 equivalent calls inferred from this helper
	if type(flag) ~= "boolean" then
		return "—"
	end

	return if flag then "Yes" else "No"
end

local function formatBitrate(p)
	if p.culled == true then
		return "—"
	end

	local incomingBitrateKbps = p.incomingBitrateKbps

	if type(incomingBitrateKbps) == "number" then
		return string.format("%.2f kbps", incomingBitrateKbps)
	end

	return "—"
end

local function formatCodec(subscription) -- 1 equivalent call inferred from this helper
	if subscription.culled == true then
		return "—"
	end

	return formatOrDash(subscription.codecName) -- inferred equivalent call
end

local function HeaderCell(props)
	return Roact.createElement("TextLabel", {
		Text = string.upper(props.text),
		Size = props.size,
		Position = props.pos,
		Font = Constants.Font.MainWindowHeader,
		TextSize = Constants.DefaultFontSize.MainWindowHeader,
		TextColor3 = Constants.Color.BorderGray,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1
	})
end

local function SubscriptionsTable(p)
	local subscriptions = p.subscriptions or {}
	local layoutOrder = p.layoutOrder

	local children = {}

	for k, subscription in subscriptions do
		local culled = subscription.culled == true
		local v8 = "subscription" .. k

		local createElement = Roact.createElement
		local v9 = {
			Size = UDim2.new(1, 0, 0, 20),
			LayoutOrder = k,
			BackgroundColor3 = TextBoxGray,
			BackgroundTransparency = culled and 0.6 or 1,
			BorderSizePixel = 0
		}

		local children2 = {
			AudioSsrc = Roact.createElement(CellLabel, {
				text = formatHexSsrc(subscription.audioSsrc), -- inferred equivalent call
				size = UDim2.new(udim, UDim.new(1, 0)),
				pos = UDim2.new(0, 0, 0, 0)
			}),
			FeedId = Roact.createElement(CellLabel, {
				text = formatOrDash(subscription.feedReferenceId), -- inferred equivalent call
				size = UDim2.new(udim2, UDim.new(1, 0)),
				pos = UDim2.new(udim, UDim.new(0, 0))
			}),
			UserId = Roact.createElement(CellLabel, {
				text = formatOrDash(subscription.userId), -- inferred equivalent call
				size = UDim2.new(udim3, UDim.new(1, 0)),
				pos = UDim2.new(v, UDim.new(0, 0))
			}),
			AudioMid = Roact.createElement(CellLabel, {
				text = formatOrDash(subscription.audioMid), -- inferred equivalent call
				size = UDim2.new(udim4, UDim.new(1, 0)),
				pos = UDim2.new(v2, UDim.new(0, 0)),
				textTruncate = Enum.TextTruncate.AtEnd
			}),
			Bitrate = 0,
			Codec = 0,
			Culled = 0,
			Muted = 0,
			MutedLocally = 0
		}

		local createElement2 = Roact.createElement
		local text

		if subscription.culled == true then
			text = "—"
		else
			local incomingBitrateKbps = subscription.incomingBitrateKbps
			text = type(incomingBitrateKbps) ~= "number" and "—" or string.format("%.2f kbps", incomingBitrateKbps)
		end

		children2.Bitrate = createElement2(CellLabel, {
			text = text,
			size = UDim2.new(udim5, UDim.new(1, 0)),
			pos = UDim2.new(v3, UDim.new(0, 0))
		})

		children2.Codec = Roact.createElement(CellLabel, {
			text = formatCodec(subscription), -- inferred equivalent call
			size = UDim2.new(udim6, UDim.new(1, 0)),
			pos = UDim2.new(v4, UDim.new(0, 0)),
			textTruncate = Enum.TextTruncate.AtEnd
		})

		children2.Culled = Roact.createElement(CellLabel, {
			text = formatBool(subscription.culled), -- inferred equivalent call
			size = UDim2.new(udim7, UDim.new(1, 0)),
			pos = UDim2.new(v5, UDim.new(0, 0))
		})

		children2.Muted = Roact.createElement(CellLabel, {
			text = formatBool(subscription.isMuted), -- inferred equivalent call
			size = UDim2.new(udim8, UDim.new(1, 0)),
			pos = UDim2.new(v6, UDim.new(0, 0))
		})

		children2.MutedLocally = Roact.createElement(CellLabel, {
			text = formatBool(subscription.isMutedLocally), -- inferred equivalent call
			size = UDim2.new(udim9, UDim.new(1, 0)),
			pos = UDim2.new(v7, UDim.new(0, 0))
		})
		children[v8] = createElement("Frame", v9, children2)
	end

	if next(children) == nil then
		children.placeholder = Roact.createElement(CellLabel, {
			text = "—",
			layoutOrder = 1,
			size = UDim2.new(1, 0, 0, 20),
			pos = UDim2.new()
		})
	end

	local element = Roact.createElement(
		"Frame",
		{ Size = UDim2.new(1, 0, 0, 20), LayoutOrder = 1, BackgroundTransparency = 1 },
		{
			AudioSsrc = Roact.createElement(HeaderCell, {
				text = "Audio Ssrc",
				size = UDim2.new(udim, UDim.new(1, 0)),
				pos = UDim2.new(0, 0, 0, 0)
			}),
			FeedId = Roact.createElement(HeaderCell, {
				text = "Feed ID",
				size = UDim2.new(udim2, UDim.new(1, 0)),
				pos = UDim2.new(udim, UDim.new(0, 0))
			}),
			UserId = Roact.createElement(HeaderCell, {
				text = "User ID",
				size = UDim2.new(udim3, UDim.new(1, 0)),
				pos = UDim2.new(v, UDim.new(0, 0))
			}),
			AudioMid = Roact.createElement(HeaderCell, {
				text = "Audio Mid",
				size = UDim2.new(udim4, UDim.new(1, 0)),
				pos = UDim2.new(v2, UDim.new(0, 0))
			}),
			Bitrate = Roact.createElement(HeaderCell, {
				text = "Bitrate",
				size = UDim2.new(udim5, UDim.new(1, 0)),
				pos = UDim2.new(v3, UDim.new(0, 0))
			}),
			Codec = Roact.createElement(HeaderCell, {
				text = "Codec",
				size = UDim2.new(udim6, UDim.new(1, 0)),
				pos = UDim2.new(v4, UDim.new(0, 0))
			}),
			Culled = Roact.createElement(HeaderCell, {
				text = "Culled",
				size = UDim2.new(udim7, UDim.new(1, 0)),
				pos = UDim2.new(v5, UDim.new(0, 0))
			}),
			Muted = Roact.createElement(HeaderCell, {
				text = "Muted",
				size = UDim2.new(udim8, UDim.new(1, 0)),
				pos = UDim2.new(v6, UDim.new(0, 0))
			}),
			MutedLocally = Roact.createElement(HeaderCell, {
				text = "Muted Locally",
				size = UDim2.new(udim9, UDim.new(1, 0)),
				pos = UDim2.new(v7, UDim.new(0, 0))
			})
		}
	)

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		},
		{
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Header = element,
			Rows = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = 2,
					BackgroundTransparency = 1
				},
				{
					UIListLayout = Roact.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Rows = Roact.createFragment(children)
				}
			)
		}
	)
end

local function SubscriptionsPanel(p)
	local subscriptions = p.subscriptions
	local layoutOrder = p.layoutOrder

	return Roact.createElement(CollapsibleSection, {
		title = "Subscriptions",
		layoutOrder = layoutOrder
	}, {
		Table = Roact.createElement(SubscriptionsTable, {
			subscriptions = subscriptions,
			layoutOrder = 1
		})
	})
end

return SubscriptionsPanel
