local Packages = game:GetService("CorePackages").Workspace.Packages

require(Packages.Navigation)

local t1 = {}

for _, v4 in (require(script.Parent.TabConfig)) do
	table.insert(t1, {
		[v4.id] = {
			getScreen = v4.getScreen
		}
	})
end

return t1
