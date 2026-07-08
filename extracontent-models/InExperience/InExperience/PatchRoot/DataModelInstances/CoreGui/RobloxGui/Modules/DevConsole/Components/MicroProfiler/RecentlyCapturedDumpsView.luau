local CorePackages = game:GetService("CorePackages")
local Constants = require(script.Parent.Parent.Parent.Constants)
local MicroProfilerPanel = require(script.Parent.MicroProfilerPanel)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local v6 = Roact.Component:extend("RecentlyCapturedDumpsView")

function v6.render(p1) -- line: 11
	-- upvalues: Roact (copy), Constants (copy), MicroProfilerPanel (copy)
	if not p1.props.RecentDumpPaths then
	end

	local t1 = {}

	for _, v in ipairs(p1.props.RecentDumpPaths) do
		table.insert(t1, {
			DumpPathLabel = Roact.createElement("TextBox", {
				TextSize = 14,
				BackgroundTransparency = 1,
				TextEditable = false,
				ClearTextOnFocus = false,
				ClipsDescendants = true,
				Font = Constants.Font.Log,
				Text = v,
				TextColor3 = Constants.Color.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				Size = UDim2.fromScale(1, 1)
			}, {
				UIPadding = Roact.createElement("UIPadding", {
					PaddingLeft = UDim.new(0, Constants.MicroProfilerFormatting.RecentDumpPathPadding),
					PaddingRight = UDim.new(0, Constants.MicroProfilerFormatting.RecentDumpPathPadding)
				})
			})
		})
	end

	if #t1 == 0 then
		table.insert(t1, {
			NoDumpsLabel = Roact.createElement("TextLabel", {
				Text = "No recently captured MicroProfiler dumps.",
				BackgroundTransparency = 1,
				Font = Constants.Font.MainWindow,
				TextColor3 = Constants.Color.Text,
				TextSize = Constants.MicroProfilerFormatting.OptionTextSize,
				TextXAlignment = Enum.TextXAlignment.Left,
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
		LayoutOrder = p1.props.LayoutOrder,
		Sections = {{
			Name = "RecentlyCapturedDumps",
			Rows = t1
		}}
	})
end

local function mapStateToProps(p2, _) -- line: 67
	return {
		RecentDumpPaths = p2.MicroProfiler.recentDumpPaths
	}
end

return RoactRodux.connect(mapStateToProps, nil)(v6)
