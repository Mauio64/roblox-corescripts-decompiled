local Players = game:GetService("Players")
local CorePackages = game:GetService("CorePackages")
local InGameMenuDependencies = require(CorePackages.Packages.InGameMenuDependencies)
local Roact = InGameMenuDependencies.Roact
local t = InGameMenuDependencies.t
local ParentParent = script.Parent.Parent
local PageNavigationWatcher = require(ParentParent.Components.PageNavigationWatcher)
local Page = require(ParentParent.Components.Page)
local ReportList = require(script.ReportList)

local function getReportablePlayers() -- line: 14
	-- upvalues: Players (copy)
	local t1 = {}

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= Players.LocalPlayer then
			table.insert(t1, player)
		end
	end

	return t1
end

local v11 = Roact.PureComponent:extend("ReportPage")

v11.validateProps = t.strictInterface({
	pageTitle = t.string
})

function v11.init(p1) -- line: 31
	-- upvalues: getReportablePlayers (copy)
	p1:setState({
		players = getReportablePlayers()
	})
end
function v11.render(p2) -- line: 37
	-- upvalues: Roact (copy), Page (copy), ReportList (copy), PageNavigationWatcher (copy), getReportablePlayers (copy)
	return Roact.createElement(Page, {
		pageTitle = p2.props.pageTitle
	}, {
		PlayerList = Roact.createElement(ReportList, {
			players = p2.state.players
		}),
		Watcher = Roact.createElement(PageNavigationWatcher, {
			desiredPage = "Report",
			onNavigateTo = function() -- line: 46
				-- upvalues: p2 (copy), getReportablePlayers (copy)
				p2:setState({
					players = getReportablePlayers()
				})
			end
		})
	})
end

return v11
