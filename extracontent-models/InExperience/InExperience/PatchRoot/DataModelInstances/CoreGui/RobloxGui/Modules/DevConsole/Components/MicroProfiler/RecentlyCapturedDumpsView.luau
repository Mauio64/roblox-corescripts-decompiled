local CorePackages = game:GetService("CorePackages")

local Constants = require(script.Parent.Parent.Parent.Constants)
local MicroProfilerPanel = require(script.Parent.MicroProfilerPanel)

local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)

local extended = Roact.Component:extend("RecentlyCapturedDumpsView")

function extended.render(p)
	local _recentDumpPaths = p.props.RecentDumpPaths
	local rows = {}

	for _, recentDumpPath in ipairs(p.props.RecentDumpPaths) do
		table.insert(rows, {
			DumpPathLabel = Roact.createElement("TextBox", {
				Font = Constants.Font.Log,
				Text = recentDumpPath,
				TextColor3 = Constants.Color.Text,
				TextSize = 14,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				TextEditable = false,
				ClearTextOnFocus = false,
				ClipsDescendants = true
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, Constants.MicroProfilerFormatting.RecentDumpPathPadding),
					PaddingRight = UDim.new(0, Constants.MicroProfilerFormatting.RecentDumpPathPadding)
				})
			})
		})
	end

	if #rows == 0 then
		table.insert(rows, {
			NoDumpsLabel = Roact.createElement("TextLabel", {
				Font = Constants.Font.MainWindow,
				Text = "No recently captured MicroProfiler dumps.",
				TextColor3 = Constants.Color.Text,
				TextSize = Constants.MicroProfilerFormatting.OptionTextSize,
				TextXAlignment = Enum.TextXAlignment.Left,
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1)
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, Constants.MicroProfilerFormatting.OptionTextPadding)
				})
			})
		})
	end

	return Roact.createElement(MicroProfilerPanel, {
		Title = "Recently captured MicroProfiler dumps",
		LayoutOrder = p.props.LayoutOrder,
		Sections = {
			{ Name = "RecentlyCapturedDumps", Rows = rows }
		}
	})
end

local function mapStateToProps(p, _)
	return { RecentDumpPaths = p.MicroProfiler.recentDumpPaths }
end

return RoactRodux.connect(mapStateToProps, nil)(extended)
