-- Defining.
local inf = 9e8
local crgb = Color3.fromRGB
local u2 = UDim2.new
local u1 = UDim.new
local uFromSc = UDim2.fromScale
local uFromOf = UDim2.fromOffset
local v2 = Vector2.new

local function cRGB(rgb)
	if #rgb == 1 then
		return crgb(rgb[1], rgb[1], rgb[1])
	end
	return crgb(unpack(rgb))
end

local cs = {
	White = cRGB{255},
	None = cRGB{0}
}

local function destroy(instances)
	if type(instances) == "table" then
		table['foreach'](instances, function(_, part)
			part:Destroy()
		end)
	else
		instances:Destroy()
	end
end

local cref = _G['cloneref'] or function(obj)
	return obj
end
local services = setmetatable({}, {
	__index = function(_, service)
		return cref(game:GetService(service))
	end,
})

local RS = services.RunService
local P = services.Players.LocalPlayer
local HTTP = services.HttpService
local UIS = game:GetService("UserInputService")
local TS = services.TweenService

local function addDrag(Frame)
	local dragToggle = nil
	local dragSpeed = 1
	local dragInput = nil
	local dragStart = nil
	local dragPos = nil
	local Delta
	local Position
	local startPos
	local function updateInput(input)
		Delta = input.Position - dragStart
		Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
		game:GetService("TweenService"):Create(Frame, TweenInfo.new(1 - math.clamp(dragSpeed, 0, 1)), {Position = Position}):Play()
	end
	Frame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
			dragToggle = true
			dragStart = input.Position
			startPos = Frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)
	Frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UIS.InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			updateInput(input)
		end
	end)
end

local ibrary = {}
local studio = RS:IsStudio()
local randomName = HTTP:GenerateGUID(true)

local AnchorPoint = {
	Mid = v2(0.5, 0.5),
	RightMid = v2(1, 0.5),
	LeftMid = v2(0, 0.5),
	BottomMid = v2(0.5, 0),
	TopMid = v2(0.5, 1),

	Right = v2(1, 0),
	Bottom = v2(0, 1),
	Top = v2(0, 1),

	BottomLeft = v2(0, 1),
	BottomRight = v2(1, 1)
}
local Position = {
	Mid = uFromSc(0.5, 0.5),
	RightMid = uFromSc(1, 0.5),
	LeftMid = uFromSc(0, 0.5),
	BottomMid = uFromSc(0.5, 0),
	TopMid = uFromSc(0.5, 1),

	Right = uFromSc(1, 0),
	Bottom = uFromSc(0, 1),
	Top = uFromSc(0, 1),

	BottomLeft = uFromSc(0, 1),
	BottomRight = uFromSc(1, 1)
}
local Size = {
	Full = uFromSc(1, 1),
	None = uFromSc(0, 0)
}

-- Create function, easier to read than a bunch of Instance.new() stuff.
local function create(name, properties, ch)
	if name == "Image" then
		return create("ImageLabel", properties, ch)
	elseif name == "Text" then
		return create("TextLabel", properties, ch)
	elseif name == "SFrame" then
		return create("ScrollingFrame", properties, ch)
	end
	local object = Instance.new(name)
	for i,v in pairs(properties or {}) do
		if i == "BG3" then
			object.BackgroundColor3 = v
		elseif i == "BT" then
			object.BackgroundTransparency = v
		elseif i == "IC3" then
			object.ImageColor3 = v
		elseif i == "TC3" then
			object.TextColor3 = v
		elseif i == "IT" then
			object.ImageTransparency = v
		elseif i == "Events" then
			for event, func in next, v do
				object[event]:Connect(func)
			end
		else
			object[i] = v
		end
	end
	for i, v in ipairs(ch or {}) do
		v.Parent = object
	end
	return object
end

local function roundedFrame(radius, properties, ch)
	local frame = create("Frame", properties, {
		create("UICorner", {
			CornerRadius = u1(0, radius)
		})
	})

	for i, v in next, (ch or {}) do
		v.Parent = frame
	end
	return frame
end

local function roundedFrame2(radius, properties, ch)
	local frame = create("Frame", properties, {
		create("UICorner", {
			CornerRadius = u1(radius, 0)
		})
	})

	for i, v in next, (ch or {}) do
		v.Parent = frame
	end
	return frame
end

local function roundedImage(radius, properties, ch)
	local frame = create("Image", properties, {
		create("UICorner", {
			CornerRadius = u1(0, radius)
		})
	})

	for i, v in next, (ch or {}) do
		v.Parent = frame
	end
	return frame
end

local function roundedImage2(radius, properties, ch)
	local frame = create("Image", properties, {
		create("UICorner", {
			CornerRadius = u1(radius, 0)
		})
	})

	for i, v in next, (ch or {}) do
		v.Parent = frame
	end
	return frame
end

-- When testing in studio, CoreGui is not available. Some Exploits do not have gethui() either
local GuiParent = studio and P.PlayerGui or (_G['gethui'] and _G['gethui']() or game.CoreGui)
local ScreenGui = create("ScreenGui", {
	Parent = GuiParent,
	ZIndexBehavior = Enum.ZIndexBehavior.Global,
	ResetOnSpawn = false,
	DisplayOrder = inf
})

-- Notifications
local NotificationContainer = create("Frame", {
	AnchorPoint = AnchorPoint.RightMid,
	BT = 1,
	Position = Position.RightMid,
	Size = u2(0, 300, 1, -35),
	Parent = ScreenGui
}, {
	create("UIListLayout", {
		Padding = u1(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		VerticalAlignment = Enum.VerticalAlignment.Bottom
	})
})

-- Window function.
function ibrary:Make(v, props)
	if (v == "Notification" or v == "Notif") then
		local Frame = roundedFrame(8, {
			BG3 = cRGB{29},
			Size = u2(0, 0, 0, 60),
			ClipsDescendants = true,
			ZIndex = 2,
			Parent = NotificationContainer
		}, {
			-- Shadow
			create("Frame", {
				BG3 = cRGB{163, 162, 165},
				BT = 1,
				Size = Size.Full,
				ZIndex = 0
			}, {
				create("Image", {
					AnchorPoint = AnchorPoint.Mid,
					BG3 = cRGB{163, 162, 165},
					BT = 1,
					Position = Position.Mid,
					Size = u2(1, 47, 1, 47),
					ZIndex = 0,
					Image = "rbxassetid://6014261993",
					IC3 = cs.None,
					IT = 0.5,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(49, 49, 450, 450),
					SliceScale = 1
				})
			}),
			-- Header
			create("Text", {
				BT = 1,
				Position = uFromOf(10, 5),
				Size = u2(1, 0, 0, 30),
				ZIndex = 2,
				TC3 = props.Theme or cRGB{255, 87, 87},
				Font = Enum.Font.SourceSans,
				TextSize = 27,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Text = props.Header,
				Name = "head"
			}),
			-- Description
			create("Text", {
				BT = 1,
				Position = uFromOf(10, 32),
				Size = u2(1, -30, 0, 25),
				ZIndex = 2,
				TC3 = cs.White,
				Font = Enum.Font.SourceSans,
				TextSize = 15,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Text = props.Description,
				Name = "desc"
			}),
			-- Frame thingy at the back idk what it is
			create("Frame", {
				AnchorPoint = AnchorPoint.Right,
				BG3 = props.Theme or cRGB{255, 87, 87},
				Position = Position.Right,
				Size = u2(0, 7, 1, 0),
				ZIndex = 2
			})
		})

		local textBounds = Frame.desc.TextBounds.X + 200
		local textbounds2 = Frame.head.TextBounds.X + 200

		if textBounds >= 400 then
			textBounds = textBounds - 160
		end

		if textbounds2 >= 400 then
			textbounds2 = textbounds2 - 160
		end

		if textBounds >= textbounds2 then
			TS:Create(Frame, TweenInfo.new(0.34, Enum.EasingStyle.Quart), {Size = u2(0, textBounds, 0, 60)}):Play()
		else
			TS:Create(Frame, TweenInfo.new(0.34, Enum.EasingStyle.Quart), {Size = u2(0, textbounds2, 0, 60)}):Play()
		end

		-- Wait the specificed duration, or 10 seconds if not chosen
		task.wait(props.Duration or 10)

		-- Destroy the notification after it is done waiting the duration
		spawn(function()
			local destroyTween = TS:Create(Frame, TweenInfo.new(0.23, Enum.EasingStyle.Quart), {Size = u2(0, 0, 0, 60)})
			destroyTween:Play()
			destroyTween.Completed:Wait()
			destroy(Frame)
		end)
	elseif (v == "Window") then
		-- Check properties validation to prevent errors.
		props = {
			Name = props.Name or "Unknown",
			Theme = props.Theme or cRGB{255, 87, 87},
			CustomBanner = props.CustomBanner or "rbxassetid://124077021993762",
			UseAnimations = (props.UseAnimations == true and true) or (props.UseAnimations == nil and true)
		}

		-- Assign for use deeper in the script
		local UiTheme = props.Theme
		local UseAnimations = props.UseAnimations

		-- OnTopOfCoreBlur allows it to show above high guis like developer console and escape menu. Cannot be used in studio, so checks are made.
		if (not studio) then
			ScreenGui.OnTopOfCoreBlur = true
		end

		-- Creating the mainframe. very important!
		local MainFrame = roundedFrame(10, {
			Parent = ScreenGui,
			BG3 = cRGB{24},
			Size = uFromOf(610, 350)
		}, {
			-- Shadow
			create("Frame", {
				BG3 = cRGB{163, 162, 165},
				BT = 1,
				Size = Size.Full,
				ZIndex = 0
			}, {
				create("Image", {
					AnchorPoint = AnchorPoint.Mid,
					BG3 = cRGB{163, 162, 165},
					BT = 1,
					Position = Position.Mid,
					Size = u2(1, 47, 1, 47),
					ZIndex = 0,
					Image = "rbxassetid://6014261993",
					IC3 = cs.None,
					IT = 0.5,
					ScaleType = Enum.ScaleType.Slice,
					SliceCenter = Rect.new(49, 49, 450, 450),
					SliceScale = 1
				})
			}),
			-- Tab Container
			create("Frame", {
				BT = 1,
				Size = u2(0, 200, 1, 0),
				Name = "container"
			}, {
				-- Banner
				roundedImage(10, {
					AnchorPoint = AnchorPoint.BottomMid,
					BT = 1,
					Position = u2(0.5, 0, 0, 10),
					Size = uFromOf(175, 75),
					Image = props.CustomBanner,
					IC3 = cs.White,
				}, {
					create("Text", {
						BT = 1,
						Size = Size.Full,
						Font = Enum.Font.Arimo,
						Text = tostring(props.Name):lower(),
						TC3 = cs.White,
						TextSize = 21,
						TextStrokeTransparency = 0
					})
				}),
				-- Actual Tab Container. these are where we can click to view the pages
				create("Frame", {
					AnchorPoint = AnchorPoint.TopMid,
					BT = 1,
					Position = u2(0.5, 0, 1, -5),
					Size = u2(1, -25, 1, -95),
					ZIndex = 2,
					ClipsDescendants = false,
					Name = "container"
				}, {
					create("SFrame", {
						BT = 1,
						Active = true,
						Size = Size.Full,
						ClipsDescendants = true,
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						CanvasSize = Size.None,
						ScrollBarThickness = 0,
						ScrollingDirection = Enum.ScrollingDirection.Y
					}, {
						create("UIListLayout", {
							Padding = u1(0, 4),
							FillDirection = Enum.FillDirection.Vertical,
							HorizontalAlignment = Enum.HorizontalAlignment.Center
						})
					})
				})
			}),
			-- Page Container
			roundedFrame(10, {
				BG3 = cRGB{21},
				AnchorPoint = AnchorPoint.Right,
				Position = Position.Right,
				Size = u2(1, -200, 1, 0),
				Name = "Pages"
			}, {
				create("Frame", {
					BG3 = cRGB{21},
					Size = u2(0, 10, 1, 0),
					BorderSizePixel = 0
				}),
				create("Frame", {
					Name = "PageContainer",
					AnchorPoint = AnchorPoint.Mid,
					BT = 1,
					Position = Position.Mid,
					Size = u2(1, -20, 1, -20)
				})
			})
		})

		-- Add Drag
		addDrag(MainFrame)

		-- Resizing when F2 is being pressed
		UIS.InputBegan:Connect(function(key, gpe)
			if gpe then return end
			if key.KeyCode == Enum.KeyCode.F2 then
				while UIS:IsKeyDown(Enum.KeyCode.F2) do
					UIS.MouseIconEnabled = false;
					MainFrame.Size = u2(
						0,
						math.clamp(P:GetMouse().X - MainFrame.Position.X.Offset, 610, math.huge),
						0,
						math.clamp(P:GetMouse().Y - MainFrame.Position.Y.Offset, 350, math.huge)
					)
					task.wait()
				end
				UIS.MouseIconEnabled = true;
			elseif key.KeyCode == Enum.KeyCode.F4 then
				local d1 = MainFrame.Size.X.Offset + (MainFrame.Position.X.Offset - P:GetMouse().X)
				local d2 = MainFrame.Size.Y.Offset + (MainFrame.Position.Y.Offset - P:GetMouse().Y)

				while UIS:IsKeyDown(Enum.KeyCode.F4) do
					UIS.MouseIconEnabled = false;
					MainFrame.Size = u2(
						0,
						math.clamp(P:GetMouse().X - MainFrame.Position.X.Offset + d1, 610, math.huge),
						0,
						math.clamp(P:GetMouse().Y - MainFrame.Position.Y.Offset + d2, 350, math.huge)
					)
					task.wait()
				end
				UIS.MouseIconEnabled = true;
			end
		end)

		-- Functions that give us tabs and stuff
		local Data = {
			Frames = {},
			Count = 0
		}
		function Data:addFrameToData(frame, page)
			Data.Frames[frame] = {
				Frame = frame,
				Page = page,
				Tweens = {}
			}
			Data.Count = Data.Count + 1
		end
		function Data:isFirstTab()
			return Data.Count == 1
		end
		function Data:Make(v, props)
			if v == "Tab" then
				local ActiveTweens = {}
				local Tab = {}
				local TabFrame
				local Page
				local onMouse1
				TabFrame = roundedFrame(5, {
					BG3 = cRGB{29},
					Size = u2(1, 0, 0, 25),
					Parent = MainFrame.container.container.ScrollingFrame,
					Name = "tab"
				}, {
					create("TextButton", {
						Text = props.Name,
						TC3 = cRGB{167},
						TextSize = 15,
						Font = Enum.Font.Arimo,
						BT = 1,
						Size = Size.Full,
						Events = {
							MouseButton1Click = function() onMouse1() end
						}
					}),
					create("Image", {
						AnchorPoint = AnchorPoint.LeftMid,
						BT = 1,
						Position = u2(0, 2, 0.5, 0),
						Size = uFromOf(18, 18),
						Image = props.Image,
						IC3 = cRGB{157},
						Name = "Icon",
						ZIndex = 2
					})
				})

				Page = create("SFrame", {
					AnchorPoint = AnchorPoint.Mid,
					BT = 1,
					Position = Position.Mid,
					Size = u2(1, -2, 1, -2),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollingDirection = Enum.ScrollingDirection.Y,
					CanvasSize = uFromSc(0, 0),
					ScrollBarThickness = 0,
					Visible = false,
					Parent = MainFrame.Pages.PageContainer,
					Name = "page"
				}, {
					create("UIListLayout", {
						Padding = u1(0, 4),
						HorizontalAlignment = Enum.HorizontalAlignment.Left,
						VerticalAlignment = Enum.VerticalAlignment.Top,
						SortOrder = Enum.SortOrder.Name
					})
				})

				-- Function to show page when the button is pressed
				function onMouse1()
					for i, v in MainFrame.container.container.ScrollingFrame:GetChildren() do
						if v.Name == "tab" then
							if v:FindFirstChild("IDK_1") then
								-- Destroy indicator
								destroy{v.IDK_1, v.IDK_2}
							end

							-- Reset to look disabled
							v.TextButton.TextColor3 = cRGB{167}
							v.Icon.ImageColor3 = cRGB{157}
							v.Icon.Position = u2(0, 2, 0.5, 0)
						end
					end

					for i, e in MainFrame.Pages.PageContainer:GetChildren() do
						if e.Name == "page" then
							e.Visible = false
						end
					end

					roundedFrame(8, {
						Parent = TabFrame,
						AnchorPoint = AnchorPoint.LeftMid,
						BG3 = UiTheme,
						Position = Position.LeftMid,
						Size = u2(0, 10, 1, 0),
						Name = "IDK_1",
						BT = 1
					}, {
						create("Frame", {
							BG3 = cRGB{29},
							AnchorPoint = AnchorPoint.RightMid,
							Position = Position.RightMid,
							Size = u2(0, 5, 1, 0),
							BorderSizePixel = 0
						})
					})
					roundedFrame(8, {
						Parent = TabFrame,
						AnchorPoint = AnchorPoint.RightMid,
						BG3 = UiTheme,
						Position = Position.RightMid,
						Size = u2(0, 10, 1, 0),
						Name = "IDK_2",
						BT = 1
					}, {
						create("Frame", {
							BG3 = cRGB{29},
							AnchorPoint = AnchorPoint.LeftMid,
							Position = Position.LeftMid,
							Size = u2(0, 5, 1, 0),
							BorderSizePixel = 0
						})
					})

					Page.Position = u2(0.5, 0, 0.5, 20)
					if UseAnimations == true then
						task.spawn(function()
							TS:Create(TabFrame.TextButton, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {TextColor3 = UiTheme}):Play()
							TS:Create(TabFrame.Icon, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {ImageColor3 = UiTheme, Position = u2(0, 8, 0.5, 0)}):Play()
							TS:Create(TabFrame.IDK_1, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {BackgroundTransparency = 0}):Play()
							TS:Create(TabFrame.IDK_2, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {BackgroundTransparency = 0}):Play()
							TS:Create(Page, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Position = Position.Mid}):Play()
						end)
					else
						TabFrame.TextButton.TextColor3 = UiTheme
						TabFrame.Icon.ImageColor3 = UiTheme
						TabFrame.Icon.Position = u2(0, 8, 0.5, 0)
						TabFrame.IDK_1.BackgroundTransparency = 0
						TabFrame.IDK_1.BackgroundTransparency = 0
						Page.Position = Position.Mid
					end
					Page.Visible = true
				end
				Data:addFrameToData(TabFrame, Page)

				-- If this is the first tab, we will automatically select it
				if (Data:isFirstTab()) then
					onMouse1()
				end


				local Sections = 0
				function Tab:AddSection(name)
					-- If we add another switch to a section above, its going to add it to the bottom of the page, obviously showing an incorrect item, To fix this we will use LayoutOrder "Name" and do something like this
					Sections = Sections + 1
					local SectionNumber = Sections

					local Section = {
						Items = {},
						Min = false
					}
					local function f()
						return tostring(SectionNumber) .. (function(x)
							local tx =  tostring(x)
							if x < 10 then
								return "000" .. tx
							elseif x < 100 and x > 9 then
								return "00" .. tx
							elseif x < 1000 and x > 99 then
								return "0" .. tx
							else
								return tx
							end
						end)(#Section.Items)
					end
					local SectionText
					SectionText = create("Text", {
						AutomaticSize = Enum.AutomaticSize.X,
						BT = 1,
						Size = uFromOf(0, 25),
						FontFace = Font.new("rbxasset://fonts/families/Arimo.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal),
						Parent = Page,
						Text = name,
						TC3 = cs.White,
						TextSize = 17,
						TextXAlignment = Enum.TextXAlignment.Left,
						Name = tostring(Sections)
					}, {
						create("ImageButton", {
							AnchorPoint = AnchorPoint.RightMid,
							BT = 1,
							Position = UDim2.new(1, 30, 0.5, 0),
							Size = uFromOf(25, 25),
							Image = "rbxassetid://112594310539001",
							IC3 = cs.White,
							Events = {
								MouseButton1Click = function()
									table['foreach'](Section.Items, function(_, v)
										v.Visible = not v.Visible
									end)
									if UseAnimations then
										Section.Min = not Section.Min
										TS:Create(SectionText.ImageButton, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {Rotation = Section.Min and 180 or 0}):Play()
									else
										if SectionText.ImageButton.Rotation ~= 180 then
											SectionText.ImageButton.Rotation = 180
										else
											SectionText.ImageButton.Rotation = 0
										end
									end
								end
							}
						})
					})
					function Section:AddSwitch(props)
						local ReturnData = {Enabled = false}

						local Switch
						Switch = roundedFrame(7, {
							BG3 = cRGB{31},
							Size = UDim2.new(1, 0, 0, 40),
							Parent = Page,
							Name = f()
						}, {
							roundedFrame(7, {
								AnchorPoint = AnchorPoint.Mid,
								Position = Position.Mid,
								BG3 = cRGB{21},
								Size = UDim2.new(1, -2, 1, -2),
							}, {
								create("Text", {
									BT = 1,
									Size = Size.Full,
									Font = Enum.Font.Arimo,
									TC3 = cRGB{233},
									Text = "  " .. (props.Name or "Unknown"),
									TextSize = 16,
									TextXAlignment = Enum.TextXAlignment.Left
								}),
								create("Frame", {
									AnchorPoint = AnchorPoint.RightMid,
									Position = u2(1, -10, 0.5, 0),
									Size = uFromOf(23, 23),
									BG3 = cRGB{29},
									BorderSizePixel = 0
								}, {
									create("Image", {
										AnchorPoint = AnchorPoint.Mid,
										BT = 1,
										Position = Position.Mid,
										Size = u2(1, -8, 1, -5),
										Image = "rbxassetid://104618387229566",
										IC3 = cs.White,
									}),
									create("TextButton", {
										Text = "",
										Size = Size.Full,
										BT = 1,
										Events = {
											MouseButton1Click = function()
												ReturnData.Enabled = not ReturnData.Enabled
												props.Function(ReturnData.Enabled) -- Callback true/false
												if UseAnimations then
													-- Yeah, this code is a bit messy, but its UI code so theres not much you can do about it. I tried
													
													local method = math.random(1, 2)
													local Size = (method == 1 and u2(0, 0, 1, -5)) or u2(1, -8, 0, 0)
													if ReturnData.Enabled then
														TS:Create(Switch.Frame.Frame.ImageLabel, TweenInfo.new(0.14, Enum.EasingStyle.Cubic), {Size = Size}):Play()
														task.wait(0.13)
														Switch.Frame.Frame.ImageLabel.Image = "rbxassetid://84581385617778"
														TS:Create(Switch.Frame.Frame.ImageLabel, TweenInfo.new(0.14, Enum.EasingStyle.Cubic), {Size = u2(1, -8, 1, -5)}):Play()
													else
														TS:Create(Switch.Frame.Frame.ImageLabel, TweenInfo.new(0.14, Enum.EasingStyle.Cubic), {Size = Size}):Play()
														task.wait(0.13)
														Switch.Frame.Frame.ImageLabel.Image = "rbxassetid://104618387229566"
														TS:Create(Switch.Frame.Frame.ImageLabel, TweenInfo.new(0.14, Enum.EasingStyle.Cubic), {Size = u2(1, -8, 1, -5)}):Play()
													end
												else
													if ReturnData.Enabled then
														Switch.Frame.Frame.ImageLabel.Image = "rbxassetid://84581385617778"
													else
														Switch.Frame.Frame.ImageLabel.Image = "rbxassetid://104618387229566"
													end
												end
											end,
										}
									})
								})
							})
						})

						table.insert(Section.Items, Switch)
						return ReturnData
					end
					function Section:AddButton(props)
						local Button
						Button = roundedFrame(7, {
							BG3 = cRGB{31},
							Size = UDim2.new(1, 0, 0, 40),
							Parent = Page,
							Name = f()
						}, {
							roundedFrame(7, {
								AnchorPoint = AnchorPoint.Mid,
								Position = Position.Mid,
								BG3 = cRGB{21},
								Size = UDim2.new(1, -2, 1, -2),
							}, {
								create("Text", {
									BT = 1,
									Size = Size.Full,
									Font = Enum.Font.Arimo,
									TC3 = cRGB{233},
									Text = "  " .. (props.Name or "Unknown"),
									TextSize = 16,
									TextXAlignment = Enum.TextXAlignment.Left
								}),
								roundedFrame(4, {
									AnchorPoint = AnchorPoint.RightMid,
									Position = u2(1, -10, 0.5, 0),
									Size = uFromOf(100, 23),
									BG3 = cRGB{29},
									BorderSizePixel = 0
								}, {
									create("TextButton", {
										BT = 1,
										Size = Size.Full,
										TC3 = cRGB{177},
										Text = props.ButtonText or "Click Me!",
										Events = {
											MouseButton1Click = props.Function,
											MouseButton1Down = function()
												Button.Frame.Frame.BackgroundColor3 = cRGB{44}
											end,
											MouseButton1Up = function()
												Button.Frame.Frame.BackgroundColor3 = cRGB{29}
											end,
										}
									})
								})
							})
						})

						table.insert(Section.Items, Button)
					end
					function Section:AddDropDown(props)
						local V = props.Def
						local DropDown
						local DropDownMenu = roundedFrame(10, {
							BT = 1,
							BG3 = cs.None,
							Size = Size.Full,
							ZIndex = 4,
							Parent = MainFrame,
							Visible = false,
							ClipsDescendants = true,
						}, {
							-- Basic uistroke without uistrokes
							roundedFrame(5, {
								BG3 = UiTheme or Color3.fromRGB(255, 87, 87),
								Position = u2(0.5, 0, 1, 275),
								AnchorPoint = AnchorPoint.Mid,
								Size = uFromOf(300, 275),
								ZIndex = 5,
								Name = "BG",
							}, {
								roundedFrame(5, {
									AnchorPoint = AnchorPoint.Mid,
									Position = Position.Mid,
									BG3 = cRGB{18},
									Size = u2(1, -4, 1, -4),
									ZIndex = 5,
									Name = "X"
								}, {
									create("Text", {
										BT = 1,
										Size = u2(1, 0, 0, 30),
										ZIndex = 5,
										Font = Enum.Font.Arimo,
										TC3 = cs.White,
										TextSize = 17,
										TextXAlignment = Enum.TextXAlignment.Left,
										Text = "  " .. (props.ChooseText or "Choose Option")
									}),
									create("SFrame", {
										AnchorPoint = AnchorPoint.BottomLeft,
										BT = 1,
										Position = u2(0, 0, 1, 0),
										Size = u2(1, -3, 1, -30),
										ZIndex = 5,
										BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
										MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
										TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
										CanvasSize = uFromSc(0, 0),
										ScrollBarThickness = 0,
										Active = true,
										Name = "S"
									}, {
										create("UIListLayout", {
											FillDirection = Enum.FillDirection.Vertical,
											HorizontalAlignment = Enum.HorizontalAlignment.Right,
											VerticalAlignment = Enum.VerticalAlignment.Top
										})
									})
								})
							})
						})
						
						local function refresh(newarray)
							-- Remove other items
							for _, Item in pairs(DropDownMenu.BG.X.S:GetChildren()) do if Item:IsA("TextButton") then destroy(Item) end end
							
							-- And now add the new ones
							for _, Item in pairs(newarray or {}) do
								local ItemButton
								ItemButton = create("TextButton", {
									Parent = DropDownMenu.BG.X.S,
									BG3 = cRGB{25},
									BT = 1,
									Size = u2(1, -30, 0, 30),
									ZIndex = 5,
									FontFace = Font.fromName("Ubuntu", Enum.FontWeight.Bold),
									TC3 = cRGB{213},
									Text = "  " .. tostring(Item),
									TextSize = 14,
									TextXAlignment = Enum.TextXAlignment.Left,
									Events = {
										MouseEnter = function()
											if UseAnimations then
												TS:Create(ItemButton, TweenInfo.new(0.15, Enum.EasingStyle.Circular), {BackgroundTransparency = 0}):Play()
											else
												ItemButton.BackgroundTransparency = 0
											end
										end,
										MouseLeave = function()
											if UseAnimations then
												TS:Create(ItemButton, TweenInfo.new(0.15, Enum.EasingStyle.Circular), {BackgroundTransparency = 1}):Play()
											else
												ItemButton.BackgroundTransparency = 1
											end
										end,
										Activated = function()
											if Item == V then
												if UseAnimations then
													TS:Create(DropDownMenu, TweenInfo.new(0.35, Enum.EasingStyle.Cubic), {BackgroundTransparency = 1}):Play()
													TS:Create(DropDownMenu.BG, TweenInfo.new(0.35, Enum.EasingStyle.Cubic), {Position = u2(0.5, 0, 1, 275)}):Play()
												else
													DropDownMenu.BackgroundTransparency = 1
													DropDownMenu.BG.Position = u2(0.5, 0, 1, 275)
												end
												return
											end
											for _, n in pairs(DropDownMenu.BG.X.S:GetChildren()) do
												if n:IsA("TextButton") and n ~= ItemButton then
													TS:Create(n.img1.img2.img3, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {ImageColor3 = cRGB{18}}):Play()
												end
											end
											
											V = Item
											TS:Create(ItemButton.img1.img2.img3, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {ImageColor3 = UiTheme or cRGB{255, 87, 87}}):Play()
											props.Function(Item)
										end,
									},
									AutoButtonColor = false,
								}, {
									create("UICorner", {CornerRadius=u1(0,5)}),
									create("Image", {
										AnchorPoint = AnchorPoint.LeftMid,
										IC3 = UiTheme or cRGB{255, 87, 87},
										BT = 1,
										Image = "rbxassetid://87511358758524", -- circ
										Position = u2(0, -23, 0.5, 0),
										Size = uFromOf(15, 15),
										ZIndex = 5,
										Name = "img1"
									}, {
										create("Image", {
											AnchorPoint = AnchorPoint.Mid,
											Position = Position.Mid,
											IC3 = cRGB{18},
											BT = 1,
											Image = "rbxassetid://87511358758524",
											Size = uFromOf(11, 11),
											ZIndex = 5,
											Name = "img2"
										}, {
											create("Image", {
												AnchorPoint = AnchorPoint.Mid,
												Position = Position.Mid,
												IC3 = Item == props.Def and (UiTheme or cRGB{255, 87, 87}) or cRGB{18},
												BT = 1,
												Image = "rbxassetid://87511358758524",
												Size = uFromOf(7, 7),
												ZIndex = 5,
												Name = "img3"
											})
										})
									})
								})
							end 
						end
						refresh(props.Array)

						
						DropDown = roundedFrame(7, {
							BG3 = cRGB{31},
							Size = UDim2.new(1, 0, 0, 40),
							Parent = Page,
							Name = f()
						}, {
							roundedFrame(7, {
								AnchorPoint = AnchorPoint.Mid,
								Position = Position.Mid,
								BG3 = cRGB{21},
								Size = UDim2.new(1, -2, 1, -2),
							}, {
								create("Text", {
									BT = 1,
									Size = Size.Full,
									Font = Enum.Font.Arimo,
									TC3 = cRGB{233},
									Text = "  " .. (props.Name or "Unknown"),
									TextSize = 16,
									TextXAlignment = Enum.TextXAlignment.Left
								}),
								roundedFrame(4, {
									AnchorPoint = AnchorPoint.RightMid,
									Position = u2(1, -10, 0.5, 0),
									Size = uFromOf(130, 23),
									BG3 = cRGB{29},
									BorderSizePixel = 0
								}, {
									create("ImageButton", {
										AnchorPoint = AnchorPoint.RightMid,
										Position = u2(1, -5, 0.5, 0),
										Size = uFromOf(16, 16),
										Image = "rbxassetid://137931036859391",
										BT = 1,
										IC3 = cRGB{177},
										Events = {
											Activated = function()
												DropDownMenu.Visible = true
												if UseAnimations then
													TS:Create(DropDownMenu, TweenInfo.new(0.35, Enum.EasingStyle.Cubic), {BackgroundTransparency = 0.2}):Play()
													TS:Create(DropDownMenu.BG, TweenInfo.new(0.35, Enum.EasingStyle.Cubic), {Position = Position.Mid}):Play()
												else
													DropDownMenu.BackgroundTransparency = 0.2
													DropDownMenu.BG.Position = Position.Mid
												end
											end
										}
									}),
									create("Text", {
										BT = 1,
										Size = u2(1, -25, 1, 0),
										ZIndex = 2,
										Font = Enum.Font.Arimo,
										TC3 = cRGB{177},
										Text = "  " .. (props.Def or "None"),
										TextXAlignment = Enum.TextXAlignment.Left,
										TextSize = 14
									})
								})
							})
						})

						table.insert(Section.Items, DropDown)
					end
					function Section:AddTextBox(props)
						local TextBox
						TextBox = roundedFrame(7, {
							BG3 = cRGB{31},
							Size = UDim2.new(1, 0, 0, 40),
							Parent = Page,
							Name = f()
						}, {
							roundedFrame(7, {
								AnchorPoint = AnchorPoint.Mid,
								Position = Position.Mid,
								BG3 = cRGB{21},
								Size = UDim2.new(1, -2, 1, -2),
							}, {
								create("Text", {
									BT = 1,
									Size = Size.Full,
									Font = Enum.Font.Arimo,
									TC3 = cRGB{233},
									Text = "  " .. (props.Name or "Unknown"),
									TextSize = 16,
									TextXAlignment = Enum.TextXAlignment.Left
								}),
								roundedFrame(4, {
									AnchorPoint = AnchorPoint.RightMid,
									Position = u2(1, -10, 0.5, 0),
									Size = uFromOf(135, 23),
									BG3 = cRGB{27},
									BorderSizePixel = 0
								}, {
									create("TextBox", {
										BT = 1,
										Size = Size.Full,
										TC3 = cRGB{227},
										PlaceholderText = props.GateText or "Input", -- GateText is PlaceHolderText. do not get confused
										TextSize = 14,
										Text = props.Def or "",
										ClipsDescendants = true,
										ClearTextOnFocus = false,
										Font = Enum.Font.SourceSans,
										Events = {
											FocusLost = function()
												if UseAnimations then
													TS:Create(TextBox.Frame.Frame, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {Size = uFromOf(135, 23)}):Play()
													TS:Create(TextBox.Frame.Frame, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {BackgroundColor3 = cRGB{27}}):Play()
												end
												props.Function(TextBox.Frame.Frame.TextBox.Text)
											end,
											Focused = function()
												if UseAnimations then
													TS:Create(TextBox.Frame.Frame, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {Size = uFromOf(135, 26)}):Play()
													TS:Create(TextBox.Frame.Frame, TweenInfo.new(0.15, Enum.EasingStyle.Sine), {BackgroundColor3 = cRGB{33}}):Play()
												end
											end,
										}
									})
								})
							})
						})

						table.insert(Section.Items, TextBox)
					end
					function Section:AddSlider(props)
						local Slider
						Slider = roundedFrame(7, {
							BG3 = cRGB{31},
							Size = UDim2.new(1, 0, 0, 60),
							Parent = Page,
							Name = f()
						}, {
							roundedFrame(7, {
								AnchorPoint = AnchorPoint.Mid,
								Position = Position.Mid,
								BG3 = cRGB{21},
								Size = UDim2.new(1, -2, 1, -2),
							}, {
								create("Text", {
									BT = 1,
									Size = Size.Full + uFromOf(0, -25),
									Font = Enum.Font.Arimo,
									TC3 = cRGB{233},
									Text = "  " .. (props.Name or "Unknown"),
									TextSize = 16,
									TextXAlignment = Enum.TextXAlignment.Left,
								}),
								roundedFrame(4, {
									AnchorPoint = AnchorPoint.BottomRight,
									Position = u2(1, -5, 1, -5),
									BG3 = cRGB{29},
									Size = u2(1, -10, 0, 23)
								}, {
									roundedFrame(4, {
										BG3 = cRGB{39},
										Size = uFromSc(0, 1)
									}),
									create("Text", {
										BT = 1,
										Size = Size.Full,
										ZIndex = 2,
										Font = Enum.Font.Arimo,
										TC3 = cRGB{177},
										Text = ("  " .. (props.Format and props.Format(props.Min)) or tostring(props.Min or "0")),
										TextSize = 14,
										TextXAlignment = Enum.TextXAlignment.Left
									}),
									create("TextButton", {
										Size = Size.Full,
										BT = 1,
										ZIndex = 3,
										Text = ""
									})
								})
							})
						})

						local Dragging = false
						UIS.InputEnded:Connect(function(input)
							-- Check if the person removes their finger from the screen (Enum.UserInputType.Touch) or if the the left button is let go of (Enum.UserInputType.MouseButton1) using InputEnded in userinputservice
							if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
								Dragging = false
							end
						end)

						local Frame = Slider.Frame.Frame

						-- Credits to Venyx for this one, i didnt know how to do the math bc im kinda dumb
						Frame.TextButton.MouseButton1Down:Connect(function()
							Dragging = true
							while Dragging do
								local sizeMath = math.clamp((P:GetMouse().X - Frame.AbsolutePosition.X) / Frame.AbsoluteSize.X, 0, 1)
								local math2 = math.floor(props.Min + (props.Max - props.Min) * sizeMath)

								if not props.Format then
									Frame.TextLabel.Text = "  " .. tostring(math2)
								else
									Frame.TextLabel.Text = "  " .. props.Format(math2)
								end

								if UseAnimations then
									TS:Create(Frame.Frame, TweenInfo.new(0.09, Enum.EasingStyle.Linear), {Size = u2(sizeMath, 0, 1, 0)}):Play()
								else
									Frame.Frame.Size = u2(sizeMath, 0, 1, 0)
								end

								task.spawn(props.Function, math2)
								task.wait() -- Add wait to prevent crashing, as we are in a loopy thing (This is basic knowledge but for any beginners, make sure you add a wait() into your repeat-until/while-do loops)
							end
						end)

						table.insert(Section.Items, Slider)
					end
					return Section
				end
				return Tab
			end
		end

		-- Give us access to the functions after doing ibrary:Make() for window
		return Data
	end
end

return ibrary
