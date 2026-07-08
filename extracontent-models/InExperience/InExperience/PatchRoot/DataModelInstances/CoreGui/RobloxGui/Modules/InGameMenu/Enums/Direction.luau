local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.enumerate)(script.Name, {
	Up = "Up",
	Down = "Down",
	Left = "Left",
	Right = "Right"
})
