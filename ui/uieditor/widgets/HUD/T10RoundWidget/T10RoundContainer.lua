require( "ui.uieditor.widgets.HUD.ZM_RoundWidget.ZmRndContainer" )

local PostLoadFunc = function ( self, controller )
	self:subscribeToGlobalModel( controller, "PerController", "gameScore.roundsPlayed", function ( model )
		PlayClip( self, "RoundAnim", controller )
	end )
end

CoD.T10RoundContainer = InheritFrom( LUI.UIElement )
CoD.T10RoundContainer.new = function ( menu, controller )
	local self = LUI.UIElement.new()

	if PreLoadFunc then
		PreLoadFunc( self, controller )
	end

	self:setUseStencil( false )
	self:setClass( CoD.T10RoundContainer )
	self.id = "T10RoundContainer"
	self.soundSet = "default"
	self:setLeftRight( true, false, 0, 1280 )
	self:setTopBottom( true, false, 0, 720 )
	self.anyChildUsesUpdateState = true

	self.Rounds = CoD.ZmRndContainer.new( menu, controller )
	self.Rounds:setLeftRight( false, true, -180, 0 )
	self.Rounds:setTopBottom( true, false, 0, 145 )
	self.Rounds:setScale( 0.95 )
	self:addElement( self.Rounds )

	self.clipsPerState = {
		DefaultState = {
			DefaultClip = function ()
				self:setupElementClipCounter( 0 )
			end,
			RoundAnim = function ()
				self:setupElementClipCounter( 1 )

				local RoundAnimFrame3 = function ( element, event )
					if not event.interrupted then
						element:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )
					end

					element:setLeftRight( false, true, -180, 0 )
					element:setTopBottom( true, false, 0, 145 )
					element:setScale( 0.95 )

					if event.interrupted then
						self.clipFinished( element, event )
					else
						element:registerEventHandler( "transition_complete_keyframe", self.clipFinished )
					end
				end

				local RoundAnimFrame2 = function ( element, event )
					if event.interrupted then
						RoundAnimFrame3( element, event )

						return 
					else
						element:beginAnimation( "keyframe", 3500, false, false, CoD.TweenType.Linear )

						element:setAlpha( 1 )

						element:registerEventHandler( "transition_complete_keyframe", RoundAnimFrame3 )
					end
				end

				local RoundAnimFrame1 = function ( element, event )
					if event.interrupted then
						RoundAnimFrame2( element, event )

						return 
					else
						element:beginAnimation( "keyframe", 250, false, false, CoD.TweenType.Linear )

						element:setLeftRight( false, true, -708, 0 )
						element:setTopBottom( true, false, 0, 190 )
						element:setScale( 1.1 )

						element:registerEventHandler( "transition_complete_keyframe", RoundAnimFrame2 )
					end
				end

				self.Rounds:completeAnimation()
				self.Rounds:setLeftRight( false, true, -180, 0 )
				self.Rounds:setTopBottom( true, false, 0, 145 )
				self.Rounds:setScale( 0.95 )
				self.Rounds:setAlpha( 1 )
				RoundAnimFrame1( self.Rounds, {} )
			end
		}
	}

	LUI.OverrideFunction_CallOriginalSecond( self, "close", function ( element )
		element.Rounds:close()
	end )
	
	if PostLoadFunc then
		PostLoadFunc( self, controller, menu )
	end
	
	return self
end
