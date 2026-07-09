local Parent = script:FindFirstAncestor("AppChat").Parent
local RoactRodux = require(Parent.RoactRodux)
local ExternalNavigationHandler = require(script.Parent.ExternalNavigationHandler)
local mapStateToProps = require(script.Parent.mapStateToProps)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(ExternalNavigationHandler)
