local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)

local Components = script.Parent.Parent.Parent.Components
local CellLabel = require(Components.CellLabel)
local BannerButton = require(Components.BannerButton)

local Constants = require(script.Parent.Parent.Parent.Constants)

local IceCandidateParser = require(script.Parent.IceCandidateParser)
local CollapsibleSection = require(script.Parent.CollapsibleSection)

require(script.Parent.VoiceDebugData)

local GetFFlagVoiceDebugConsoleV2 = require(script.Parent.GetFFlagVoiceDebugConsoleV2)

local MainRowPadding = Constants.GeneralFormatting.MainRowPadding

local udim = UDim.new(0.55, 0)
local udim2 = UDim.new(0.25, 0)
local udim3 = UDim.new(0.2, 0)
local udim4 = UDim.new(0.4, 0)
local udim5 = UDim.new(0.3, 0)

local HoverGreen = Constants.Color.HoverGreen
local WarningYellow = Constants.Color.WarningYellow
local ErrorRed = Constants.Color.ErrorRed
local UnselectedGray = Constants.Color.UnselectedGray

local v = { complete = true, completed = true, connected = true, stable = true }
local v2 = { checking = true, connecting = true, new = true }
local v3 = { failed = true, disconnected = true, closed = true }

local v4 = {
	host = { background = Color3.fromRGB(13, 39, 64), text = Color3.fromRGB(95, 184, 255) },
	srflx = { background = Color3.fromRGB(42, 26, 48), text = Color3.fromRGB(176, 122, 240) },
	relay = { background = Color3.fromRGB(42, 32, 16), text = Color3.fromRGB(224, 176, 64) },
	prflx = { background = Color3.fromRGB(16, 42, 32), text = Color3.fromRGB(96, 200, 160) }
}

local v5 = { background = Color3.fromRGB(28, 28, 28), text = Color3.fromRGB(107, 111, 117) }

local udim6 = UDim.new(0.17, 0)
local udim7 = UDim.new(0.14, 0)
local udim8 = UDim.new(0.25, 0)
local udim9 = UDim.new(0.14, 0)
local udim10 = UDim.new(0.17, 0)
local udim11 = UDim.new(0.13, 0)

local function richTextEscape(value: string) -- 3 equivalent calls inferred from this helper
	return (string.gsub(value, "[<>&\"']", {
		["<"] = "&lt;",
		[">"] = "&gt;",
		["&"] = "&amp;",
		["\""] = "&quot;",
		["'"] = "&apos;"
	}))
end

local function GroupHeader(props)
	local v6 = richTextEscape(props.title) -- inferred equivalent call
	local subtitle = props.subtitle

	local text = string.format("<b>%s</b>", v6)

	if subtitle then
		text ..= string.format("  <font color=\"#%s\">%s</font>", "B8B8B8", richTextEscape(subtitle)) -- inferred equivalent call
	end

	return Roact.createElement(CellLabel, {
		text = text,
		richText = true,
		layoutOrder = props.layoutOrder,
		size = UDim2.new(1, 0, 0, 20),
		pos = UDim2.new()
	})
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

local function formatLegState(p: string?) -- 8 equivalent calls inferred from this helper
	return if p == nil or p == "" then "—" else p
end

local function statusDotColor(p: string?) -- 2 equivalent calls inferred from this helper
	if p == nil then
		return UnselectedGray
	end

	if v[p] then
		return HoverGreen
	end

	if v2[p] then
		return WarningYellow
	end

	return if v3[p] then ErrorRed else UnselectedGray
end

local function isAlertColor(color: Color3?): boolean -- 2 equivalent calls inferred from this helper
	return color == WarningYellow or color == ErrorRed
end

local function LegCell(props)
	local color = props.color
	local text = props.text
	local size = props.size
	local pos = props.pos
	local v6 = color and 12 or 0
	return Roact.createElement("Frame", { Size = size, Position = pos, BackgroundTransparency = 1 }, {
		Dot = color and Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(0, 7, 0, 7),
			BackgroundColor3 = color,
			BorderSizePixel = 0
		}, {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(1, 0) })
		}) or nil,
		Value = Roact.createElement(CellLabel, {
			text = text,
			size = UDim2.new(1, -v6, 1, 0),
			pos = UDim2.new(0, v6, 0, 0)
		})
	})
end

local function formatSelectedCandidatePair(p: string?, p2: string?, p3: string?)
	if p == nil or p == "" or p2 == nil or p2 == "" then
		return nil
	end

	if p3 and p3 ~= "" then
		return string.format("%s ↔ %s (%s)", p, p2, p3)
	end

	return string.format("%s ↔ %s", p, p2)
end

local function TransportStateTable(p)
	local connectivity = p.connectivity or {}
	local layoutOrder = p.layoutOrder
	local fFlagVoiceDebugConsoleV2 = GetFFlagVoiceDebugConsoleV2()

	local v6 = {
		{
			label = "ICE gathering",
			publish = connectivity.iceGatheringStatePublish,
			subscribe = connectivity.iceGatheringStateSubscribe
		},
		{
			label = "ICE connection",
			publish = connectivity.iceConnectionStatePublish,
			subscribe = connectivity.iceConnectionStateSubscribe
		},
		{
			label = "Signaling",
			publish = connectivity.signalingStatePublish,
			subscribe = connectivity.signalingStateSubscribe
		}
	}

	local children = {}

	for k, v7 in v6 do
		local color

		if fFlagVoiceDebugConsoleV2 then
			color = statusDotColor(v7.publish) or nil -- inferred equivalent call
		end

		local color2

		if fFlagVoiceDebugConsoleV2 then
			color2 = statusDotColor(v7.subscribe) or nil -- inferred equivalent call
		end

		local v8 = fFlagVoiceDebugConsoleV2 and (isAlertColor(color) or isAlertColor(color2)) -- inferred equivalent call
		local v9 = "row" .. k
		local createElement = Roact.createElement
		local v10 = { Size = UDim2.new(1, 0, 0, 20), LayoutOrder = k, BackgroundTransparency = 1 }
		local accent

		if fFlagVoiceDebugConsoleV2 then
			accent = Roact.createElement("Frame", {
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0, 2, 1, 0),
				BackgroundColor3 = Constants.Color.WarningYellow,
				BackgroundTransparency = v8 and 0 or 1,
				BorderSizePixel = 0
			}) or nil
		end

		children[v9] = createElement("Frame", v10, {
			Accent = accent,
			Label = Roact.createElement(CellLabel, {
				text = v7.label,
				size = UDim2.new(udim4, UDim.new(1, 0)),
				pos = UDim2.new(0, 0, 0, 0),
				textTruncate = Enum.TextTruncate.AtEnd
			}),
			Publish = Roact.createElement(LegCell, {
				text = formatLegState(v7.publish), -- inferred equivalent call
				color = color,
				size = UDim2.new(udim5, UDim.new(1, 0)),
				pos = UDim2.new(udim4, UDim.new(0, 0))
			}),
			Subscribe = Roact.createElement(LegCell, {
				text = formatLegState(v7.subscribe), -- inferred equivalent call
				color = color2,
				size = UDim2.new(udim5, UDim.new(1, 0)),
				pos = UDim2.new(udim4 + udim5, UDim.new(0, 0))
			})
		})
	end

	local rebootCount

	if connectivity.rebootCount then
		rebootCount = tostring(connectivity.rebootCount) or nil
	end

	children.restartRow = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 20),
		LayoutOrder = #v6 + 1,
		BackgroundTransparency = 1
	}, {
		Label = Roact.createElement(CellLabel, {
			text = "ICE restarts (this session)",
			size = UDim2.new(udim4, UDim.new(1, 0)),
			pos = UDim2.new(0, 0, 0, 0),
			textTruncate = Enum.TextTruncate.AtEnd
		}),
		Publish = Roact.createElement(LegCell, {
			text = formatLegState(rebootCount), -- inferred equivalent call
			size = UDim2.new(udim5, UDim.new(1, 0)),
			pos = UDim2.new(udim4, UDim.new(0, 0))
		}),
		Subscribe = Roact.createElement(LegCell, {
			text = formatLegState(rebootCount), -- inferred equivalent call
			size = UDim2.new(udim5, UDim.new(1, 0)),
			pos = UDim2.new(udim4 + udim5, UDim.new(0, 0))
		})
	})
	local v7

	if connectivity.timeToConnectedMs and connectivity.timeToConnectedMs > 0 then
		v7 = string.format("%.0f ms", connectivity.timeToConnectedMs)
	end

	children.timeToConnectedRow = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 20),
		LayoutOrder = #v6 + 2,
		BackgroundTransparency = 1
	}, {
		Label = Roact.createElement(CellLabel, {
			text = "Time to connected",
			size = UDim2.new(udim4, UDim.new(1, 0)),
			pos = UDim2.new(0, 0, 0, 0),
			textTruncate = Enum.TextTruncate.AtEnd
		}),
		Publish = Roact.createElement(LegCell, {
			text = formatLegState(v7), -- inferred equivalent call
			size = UDim2.new(udim5, UDim.new(1, 0)),
			pos = UDim2.new(udim4, UDim.new(0, 0))
		}),
		Subscribe = Roact.createElement(LegCell, {
			text = formatLegState(v7), -- inferred equivalent call
			size = UDim2.new(udim5, UDim.new(1, 0)),
			pos = UDim2.new(udim4 + udim5, UDim.new(0, 0))
		})
	})

	local v8 = formatSelectedCandidatePair(
		connectivity.selectedCandidatePairLocalTypePublish,
		connectivity.selectedCandidatePairRemoteTypePublish,
		connectivity.selectedCandidatePairLocalProtocolPublish
	)

	local v9 = formatSelectedCandidatePair(
		connectivity.selectedCandidatePairLocalTypeSubscribe,
		connectivity.selectedCandidatePairRemoteTypeSubscribe,
		connectivity.selectedCandidatePairLocalProtocolSubscribe
	)

	children.selectedCandidatePairRow = Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 20),
		LayoutOrder = #v6 + 3,
		BackgroundTransparency = 1
	}, {
		Label = Roact.createElement(CellLabel, {
			text = "Selected candidate pair",
			size = UDim2.new(udim4, UDim.new(1, 0)),
			pos = UDim2.new(0, 0, 0, 0),
			textTruncate = Enum.TextTruncate.AtEnd
		}),
		Publish = Roact.createElement(LegCell, {
			text = formatLegState(v8), -- inferred equivalent call
			size = UDim2.new(udim5, UDim.new(1, 0)),
			pos = UDim2.new(udim4, UDim.new(0, 0))
		}),
		Subscribe = Roact.createElement(LegCell, {
			text = formatLegState(v9), -- inferred equivalent call
			size = UDim2.new(udim5, UDim.new(1, 0)),
			pos = UDim2.new(udim4 + udim5, UDim.new(0, 0))
		})
	})

	local createElement = Roact.createElement
	local v10 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}

	local children2 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Title = fFlagVoiceDebugConsoleV2 and Roact.createElement(GroupHeader, {
			title = "Transport state",
			subtitle = "publish / subscribe compared",
			layoutOrder = 1
		}) or Roact.createElement(CellLabel, {
			text = "Transport state",
			bold = true,
			layoutOrder = 1,
			size = UDim2.new(1, 0, 0, 20),
			pos = UDim2.new()
		}),
		Header = 0,
		Rows = 0
	}

	local createElement2 = Roact.createElement

	local v11 = { Size = UDim2.new(1, 0, 0, 20), LayoutOrder = 2, BackgroundTransparency = 1 }
	local v12

	if fFlagVoiceDebugConsoleV2 then
		v12 = {
			Label = Roact.createElement(CellLabel, {
				text = "",
				size = UDim2.new(udim4, UDim.new(1, 0)),
				pos = UDim2.new(0, 0, 0, 0)
			}),
			Publish = Roact.createElement(HeaderCell, {
				text = "Publish",
				size = UDim2.new(udim5, UDim.new(1, 0)),
				pos = UDim2.new(udim4, UDim.new(0, 0))
			}),
			Subscribe = Roact.createElement(HeaderCell, {
				text = "Subscribe",
				size = UDim2.new(udim5, UDim.new(1, 0)),
				pos = UDim2.new(udim4 + udim5, UDim.new(0, 0))
			})
		}
	else
		v12 = {
			Label = Roact.createElement(CellLabel, {
				text = "",
				size = UDim2.new(udim4, UDim.new(1, 0)),
				pos = UDim2.new(0, 0, 0, 0)
			}),
			Publish = Roact.createElement(CellLabel, {
				text = "PUBLISH",
				bold = true,
				size = UDim2.new(udim5, UDim.new(1, 0)),
				pos = UDim2.new(udim4, UDim.new(0, 0))
			}),
			Subscribe = Roact.createElement(CellLabel, {
				text = "SUBSCRIBE",
				bold = true,
				size = UDim2.new(udim5, UDim.new(1, 0)),
				pos = UDim2.new(udim4 + udim5, UDim.new(0, 0))
			})
		}
	end

	children2.Header = createElement2("Frame", v11, v12)

	children2.Rows = Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 3,
			BackgroundTransparency = 1
		},
		{
			UIListLayout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Rows = Roact.createFragment(children)
		}
	)
	return createElement("Frame", v10, children2)
end

local function formatMLineIndex(candidate) -- 2 equivalent calls inferred from this helper
	local sdpMLineIndex = candidate.sdpMLineIndex

	if sdpMLineIndex == nil then
		return "—"
	end

	return (tostring(sdpMLineIndex))
end

local function formatOrDash(p: string?) -- 5 equivalent calls inferred from this helper
	return if p == nil or p == "" then "—" else p
end

local function TypePill(props)
	local candidateType = props.candidateType
	local v6 = candidateType and v4[candidateType] or v5

	return Roact.createElement("Frame", {
		Size = props.size,
		Position = props.pos,
		BackgroundTransparency = 1
	}, {
		Pill = Roact.createElement("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.new(0, 0, 0, 16),
			AutomaticSize = Enum.AutomaticSize.X,
			BackgroundColor3 = v6.background,
			BorderSizePixel = 0
		}, {
			Corner = Roact.createElement("UICorner", { CornerRadius = UDim.new(0, 8) }),
			Padding = Roact.createElement("UIPadding", {
				PaddingLeft = UDim.new(0, 7),
				PaddingRight = UDim.new(0, 7)
			}),
			Label = Roact.createElement("TextLabel", {
				Text = formatOrDash(candidateType), -- inferred equivalent call
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Font = Constants.Font.MainWindow,
				TextSize = Constants.DefaultFontSize.MainWindow - 2,
				TextColor3 = v6.text,
				TextXAlignment = Enum.TextXAlignment.Center,
				BackgroundTransparency = 1
			})
		})
	})
end

local v6 = {}
local function parseIceCandidateCached(p: string?)
	if not p then
		return IceCandidateParser(p)
	end

	local v7 = v6[p]

	if v7 == nil then
		v7 = IceCandidateParser(p)
		v6[p] = v7
	end

	return v7
end

local function CandidateTable(props)
	local title = props.title
	local candidates = props.candidates or {}
	local layoutOrder = props.layoutOrder
	local fFlagVoiceDebugConsoleV2 = GetFFlagVoiceDebugConsoleV2()

	local children = {}

	for k, candidate in candidates do
		if fFlagVoiceDebugConsoleV2 then
			local candidate2 = candidate.candidate
			local v7

			if candidate2 then
				v7 = v6[candidate2]

				if v7 == nil then
					v7 = IceCandidateParser(candidate2)
					v6[candidate2] = v7
				end
			else
				v7 = IceCandidateParser(candidate2)
			end

			local v8 = "candidate" .. k
			children[v8] = Roact.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 0, 20), LayoutOrder = k, BackgroundTransparency = 1 },
				{
					Type = Roact.createElement(TypePill, {
						candidateType = v7.candidateType,
						size = UDim2.new(udim6, UDim.new(1, 0)),
						pos = UDim2.new(0, 0, 0, 0)
					}),
					Proto = Roact.createElement(CellLabel, {
						text = formatOrDash(v7.protocol), -- inferred equivalent call
						size = UDim2.new(udim7, UDim.new(1, 0)),
						pos = UDim2.new(udim6, UDim.new(0, 0))
					}),
					Priority = Roact.createElement(CellLabel, {
						text = formatOrDash(v7.priority), -- inferred equivalent call
						size = UDim2.new(udim8, UDim.new(1, 0)),
						pos = UDim2.new(udim6 + udim7, UDim.new(0, 0))
					}),
					Comp = Roact.createElement(CellLabel, {
						text = formatOrDash(v7.component), -- inferred equivalent call
						size = UDim2.new(udim9, UDim.new(1, 0)),
						pos = UDim2.new(udim6 + udim7 + udim8, UDim.new(0, 0))
					}),
					Mid = Roact.createElement(CellLabel, {
						text = formatOrDash(candidate.sdpMid), -- inferred equivalent call
						size = UDim2.new(udim10, UDim.new(1, 0)),
						pos = UDim2.new(udim6 + udim7 + udim8 + udim9, UDim.new(0, 0)),
						textTruncate = Enum.TextTruncate.AtEnd
					}),
					Idx = Roact.createElement(CellLabel, {
						text = formatMLineIndex(candidate), -- inferred equivalent call
						size = UDim2.new(udim11, UDim.new(1, 0)),
						pos = UDim2.new(udim6 + udim7 + udim8 + udim9 + udim10, UDim.new(0, 0))
					})
				}
			)
		else
			local v7 = "candidate" .. k
			children[v7] = Roact.createElement(
				"Frame",
				{ Size = UDim2.new(1, 0, 0, 20), LayoutOrder = k, BackgroundTransparency = 1 },
				{
					Candidate = Roact.createElement(CellLabel, {
						text = candidate.candidate,
						size = UDim2.new(udim, UDim.new(1, 0)),
						pos = UDim2.new(0, 0, 0, 0),
						textTruncate = Enum.TextTruncate.AtEnd
					}),
					SdpMid = Roact.createElement(CellLabel, {
						text = candidate.sdpMid,
						size = UDim2.new(udim2, UDim.new(1, 0)),
						pos = UDim2.new(udim, UDim.new(0, 0)),
						textTruncate = Enum.TextTruncate.AtEnd
					}),
					SdpMLineIndex = Roact.createElement(CellLabel, {
						text = formatMLineIndex(candidate), -- inferred equivalent call
						size = UDim2.new(udim3, UDim.new(1, 0)),
						pos = UDim2.new(udim + udim2, UDim.new(0, 0))
					})
				}
			)
		end
	end

	if next(children) == nil then
		children.placeholder = Roact.createElement(CellLabel, {
			text = "—",
			layoutOrder = 1,
			size = UDim2.new(1, 0, 0, 20),
			pos = UDim2.new()
		})
	end

	local header

	if fFlagVoiceDebugConsoleV2 then
		header = Roact.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 20), LayoutOrder = 2, BackgroundTransparency = 1 },
			{
				Type = Roact.createElement(HeaderCell, {
					text = "Type",
					size = UDim2.new(udim6, UDim.new(1, 0)),
					pos = UDim2.new(0, 0, 0, 0)
				}),
				Proto = Roact.createElement(HeaderCell, {
					text = "Proto",
					size = UDim2.new(udim7, UDim.new(1, 0)),
					pos = UDim2.new(udim6, UDim.new(0, 0))
				}),
				Priority = Roact.createElement(HeaderCell, {
					text = "Priority",
					size = UDim2.new(udim8, UDim.new(1, 0)),
					pos = UDim2.new(udim6 + udim7, UDim.new(0, 0))
				}),
				Comp = Roact.createElement(HeaderCell, {
					text = "Comp",
					size = UDim2.new(udim9, UDim.new(1, 0)),
					pos = UDim2.new(udim6 + udim7 + udim8, UDim.new(0, 0))
				}),
				Mid = Roact.createElement(HeaderCell, {
					text = "Mid",
					size = UDim2.new(udim10, UDim.new(1, 0)),
					pos = UDim2.new(udim6 + udim7 + udim8 + udim9, UDim.new(0, 0))
				}),
				Idx = Roact.createElement(HeaderCell, {
					text = "Idx",
					size = UDim2.new(udim11, UDim.new(1, 0)),
					pos = UDim2.new(udim6 + udim7 + udim8 + udim9 + udim10, UDim.new(0, 0))
				})
			}
		)
	else
		header = Roact.createElement(
			"Frame",
			{ Size = UDim2.new(1, 0, 0, 20), LayoutOrder = 2, BackgroundTransparency = 1 },
			{
				Candidate = Roact.createElement(CellLabel, {
					text = "CANDIDATE",
					bold = true,
					size = UDim2.new(udim, UDim.new(1, 0)),
					pos = UDim2.new(0, 0, 0, 0)
				}),
				SdpMid = Roact.createElement(CellLabel, {
					text = "SDP MID",
					bold = true,
					size = UDim2.new(udim2, UDim.new(1, 0)),
					pos = UDim2.new(udim, UDim.new(0, 0))
				}),
				SdpMLineIndex = Roact.createElement(CellLabel, {
					text = "SDP MLINE INDEX",
					bold = true,
					size = UDim2.new(udim3, UDim.new(1, 0)),
					pos = UDim2.new(udim + udim2, UDim.new(0, 0))
				})
			}
		)
	end

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
			Title = fFlagVoiceDebugConsoleV2 and Roact.createElement(GroupHeader, {
				title = title,
				subtitle = string.format("%d local", #candidates),
				layoutOrder = 1
			}) or Roact.createElement(CellLabel, {
				text = title,
				bold = true,
				layoutOrder = 1,
				size = UDim2.new(1, 0, 0, 20),
				pos = UDim2.new()
			}),
			Header = header,
			Rows = Roact.createElement(
				"Frame",
				{
					Size = UDim2.new(1, 0, 0, 0),
					AutomaticSize = Enum.AutomaticSize.Y,
					LayoutOrder = 3,
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

local function toRichTextSdp(value: string?) -- 1 equivalent call inferred from this helper
	if value == nil then
		return nil
	end

	return (string.gsub(
		richTextEscape(value), -- inferred equivalent call
		"redacted",
		string.format("<font color=\"#%s\">redacted</font>", "6B6F75")
	))
end

local extended = Roact.PureComponent:extend("SdpSection")

function extended:init()
	self.state = { expanded = false }

	function self.onButtonPress()
		self:setState(function(p)
			return {
				expanded = not p.expanded
			}
		end)
	end
end

function extended.render(props)
	local label = props.props.label

	local text = props.props.sdp
	local layoutOrder = props.props.layoutOrder
	local richText = GetFFlagVoiceDebugConsoleV2()
	local isExpandable

	if text == nil then
		isExpandable = false
	else
		isExpandable = text ~= ""
	end

	if richText and isExpandable then
		text = toRichTextSdp(text) or text -- inferred equivalent call
	end

	local createElement = Roact.createElement
	local v7 = {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder
	}

	local v8 = {
		UIListLayout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder
		}),
		Button = 0,
		Content = 0
	}

	local createElement2 = Roact.createElement
	local v9 = {
		size = UDim2.new(1, 0, 0, 20),
		isExpanded = props.state.expanded,
		isExpandable = isExpandable,
		hideLines = true,
		onButtonPress = 0,
		layoutOrder = 1
	}
	local onButtonPress

	if isExpandable then
		onButtonPress = props.onButtonPress or nil
	end

	v9.onButtonPress = onButtonPress
	v8.Button = createElement2(BannerButton, v9, {
		Label = Roact.createElement(CellLabel, {
			text = isExpandable and label or string.format("%s: —", label),
			size = UDim2.new(1, -20, 1, 0),
			pos = UDim2.new(0, 20, 0, 0)
		})
	})
	local content

	if isExpandable and props.state.expanded then
		content = Roact.createElement("TextLabel", {
			Text = text,
			RichText = richText,
			TextSize = richText and Constants.DefaultFontSize.MainWindow - 3 or Constants.DefaultFontSize.MainWindow,
			TextColor3 = Constants.Color.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			TextWrapped = true,
			Font = Constants.Font.MainWindow,
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Size = UDim2.new(1, -20, 0, 0),
			Position = UDim2.new(0, 20, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y
		}) or nil
	end

	v8.Content = content
	return createElement("Frame", v7, v8)
end

local function ConnectivityPanel(p)
	local connectivity = p.connectivity or {}
	local layoutOrder = p.layoutOrder
	local fFlagVoiceDebugConsoleV2 = GetFFlagVoiceDebugConsoleV2()
	local transportState

	if fFlagVoiceDebugConsoleV2 then
		transportState = Roact.createElement(TransportStateTable, {
				connectivity = connectivity,
				layoutOrder = 1
			})
			or nil
	end

	local children = {
		TransportState = transportState,
		PublishCandidates = Roact.createElement(CandidateTable, {
			title = "Publish ICE candidates",
			candidates = connectivity.icePublishCandidates,
			layoutOrder = 2
		}),
		SubscribeCandidates = Roact.createElement(CandidateTable, {
			title = "Subscribe ICE candidates",
			candidates = connectivity.iceSubscribeCandidates,
			layoutOrder = 3
		}),
		SessionDescriptionsHeader = fFlagVoiceDebugConsoleV2 and Roact.createElement(GroupHeader, {
			title = "Session descriptions",
			subtitle = "addresses redacted",
			layoutOrder = 4
		}) or nil,
		PublishOffer = Roact.createElement(extended, {
			label = "Publish offer",
			sdp = connectivity.sdpPublishOffer,
			layoutOrder = 5
		}),
		PublishRemoteAnswer = Roact.createElement(extended, {
			label = "Publish remote answer",
			sdp = connectivity.sdpPublishRemoteAnswer,
			layoutOrder = 6
		}),
		SubscribeRemoteOffer = Roact.createElement(extended, {
			label = "Subscribe remote offer",
			sdp = connectivity.sdpSubscribeRemoteOffer,
			layoutOrder = 7
		}),
		SubscribeAnswer = Roact.createElement(extended, {
			label = "Subscribe answer",
			sdp = connectivity.sdpSubscribeAnswer,
			layoutOrder = 8
		})
	}

	if fFlagVoiceDebugConsoleV2 then
		return Roact.createElement(CollapsibleSection, {
			title = "Connectivity",
			layoutOrder = layoutOrder
		}, children)
	end

	children.UIListLayout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, MainRowPadding)
	})

	children.SectionHeader = Roact.createElement(CellLabel, {
		text = "CONNECTIVITY",
		bold = true,
		layoutOrder = 0,
		size = UDim2.new(1, 0, 0, 20),
		pos = UDim2.new()
	})

	return Roact.createElement(
		"Frame",
		{
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			LayoutOrder = layoutOrder
		},
		children
	)
end

return ConnectivityPanel
