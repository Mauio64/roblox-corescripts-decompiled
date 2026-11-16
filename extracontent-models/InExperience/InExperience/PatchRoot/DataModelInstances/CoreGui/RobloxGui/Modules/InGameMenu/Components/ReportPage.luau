local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")

local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t

local parent = script.Parent.Parent

local PageNavigationWatcher = require(parent.Components.PageNavigationWatcher)
local Page = require(parent.Components.Page)
local ReportList = require(script.ReportList)

local function getReportablePlayers()
	local reportablePlayers = {}

	for _, v in ipairs(Players:GetPlayers()) do
		if v ~= Players.LocalPlayer then
			table.insert(reportablePlayers, v)
		end
	end

	return reportablePlayers
end

local extended = Roact.PureComponent:extend("ReportPage")
extended.validateProps = t.strictInterface({ pageTitle = t.string })

function extended.init(object)
	object:setState({ players = getReportablePlayers() })
end

function extended.render(object)
	return Roact.createElement(Page, { pageTitle = object.props.pageTitle }, {
		PlayerList = Roact.createElement(ReportList, { players = object.state.players }),
		Watcher = Roact.createElement(PageNavigationWatcher, {
			desiredPage = "Report",
			onNavigateTo = function()
				object:setState({ players = getReportablePlayers() })
			end
		})
	})
end

return extended
