local directory = workspace["DryOfficial's Morph System"]
directory.Scripts.Parent = game:GetService('ServerScriptService')
directory.Morph.Parent = game:GetService('ReplicatedStorage')
directory.Uniforms.Parent = game:GetService('Workspace')
local gui = Instance.new('ScreenGui')
gui.Parent = game:GetService('StarterGui')
gui.Name = ''
local text = Instance.new('TextLabel')
text.Parent = gui
text.Size = UDim2.fromScale(1,1)
text.BackgroundTransparency = 1
text.TextStrokeTransparency = 0
text.TextColor3 = Color3.new(1,1,1)
text.Text = 'LOADING DONE!'
game:GetService('TweenService'):Create(text, TweenInfo.new(5), {TextTransparency = 1}):Play()
game:GetService('Debris'):AddItem(text, 5)
