local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.enumerate)("BackButtonAction", {
	"GoBack",
	"Unhandled",
	"NoOp"
})
