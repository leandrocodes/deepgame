package scripts;

import com.stencyl.graphics.G;
import com.stencyl.graphics.BitmapWrapper;

import com.stencyl.behavior.Script;
import com.stencyl.behavior.Script.*;
import com.stencyl.behavior.ActorScript;
import com.stencyl.behavior.SceneScript;
import com.stencyl.behavior.TimedTask;

import com.stencyl.models.Actor;
import com.stencyl.models.GameModel;
import com.stencyl.models.actor.Animation;
import com.stencyl.models.actor.ActorType;
import com.stencyl.models.actor.Collision;
import com.stencyl.models.actor.Group;
import com.stencyl.models.Scene;
import com.stencyl.models.Sound;
import com.stencyl.models.Region;
import com.stencyl.models.Font;
import com.stencyl.models.Joystick;

import com.stencyl.Engine;
import com.stencyl.Input;
import com.stencyl.Key;
import com.stencyl.utils.Utils;

import openfl.ui.Mouse;
import openfl.display.Graphics;
import openfl.display.BlendMode;
import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.TouchEvent;
import openfl.net.URLLoader;

import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2Fixture;
import box2D.dynamics.joints.B2Joint;

import motion.Actuate;
import motion.easing.Back;
import motion.easing.Cubic;
import motion.easing.Elastic;
import motion.easing.Expo;
import motion.easing.Linear;
import motion.easing.Quad;
import motion.easing.Quart;
import motion.easing.Quint;
import motion.easing.Sine;

import com.stencyl.graphics.shaders.BasicShader;
import com.stencyl.graphics.shaders.GrayscaleShader;
import com.stencyl.graphics.shaders.SepiaShader;
import com.stencyl.graphics.shaders.InvertShader;
import com.stencyl.graphics.shaders.GrainShader;
import com.stencyl.graphics.shaders.ExternalShader;
import com.stencyl.graphics.shaders.InlineShader;
import com.stencyl.graphics.shaders.BlurShader;
import com.stencyl.graphics.shaders.SharpenShader;
import com.stencyl.graphics.shaders.ScanlineShader;
import com.stencyl.graphics.shaders.CSBShader;
import com.stencyl.graphics.shaders.HueShader;
import com.stencyl.graphics.shaders.TintShader;
import com.stencyl.graphics.shaders.BloomShader;



class Design_25_25_SmartCamera extends ActorScript
{
	public var _cameraX:Float;
	public var _cameraY:Float;
	public var _HorizontalEasing:Float;
	public var _maxX:Float;
	public var _leftX:Float;
	public var _BackwardsDist:Float;
	public var _Started:Bool;
	public var _VerticalEasing:Float;
	public var _LookAheadDistance:Float;
	public var _FacingLeft:Bool;
	public var _lookAhead:Float;
	public var _lookAhead2:Float;
	public var _LookLeftControl:String;
	public var _LookRightControl:String;
	
	
	public function new(dummy:Int, actor:Actor, dummy2:Engine)
	{
		super(actor);
		nameMap.set("Actor", "actor");
		nameMap.set("cameraX", "_cameraX");
		_cameraX = 0.0;
		nameMap.set("cameraY", "_cameraY");
		_cameraY = 0.0;
		nameMap.set("Horizontal Easing", "_HorizontalEasing");
		_HorizontalEasing = 16.0;
		nameMap.set("maxX", "_maxX");
		_maxX = 0.0;
		nameMap.set("leftX", "_leftX");
		_leftX = 0.0;
		nameMap.set("Backwards Distance", "_BackwardsDist");
		_BackwardsDist = -1.0;
		nameMap.set("Started?", "_Started");
		_Started = false;
		nameMap.set("Vertical Easing", "_VerticalEasing");
		_VerticalEasing = 16.0;
		nameMap.set("Look-Ahead Distance", "_LookAheadDistance");
		_LookAheadDistance = 32.0;
		nameMap.set("Facing Left?", "_FacingLeft");
		_FacingLeft = false;
		nameMap.set("lookAhead", "_lookAhead");
		_lookAhead = 0.0;
		nameMap.set("lookAhead2", "_lookAhead2");
		_lookAhead2 = 0.0;
		nameMap.set("Look Left Control", "_LookLeftControl");
		nameMap.set("Look Right Control", "_LookRightControl");
		
	}
	
	override public function init()
	{
		
		/* ======================== When Creating ========================= */
		_cameraX = asNumber(actor.getXCenter());
		propertyChanged("_cameraX", _cameraX);
		_cameraY = asNumber(actor.getYCenter());
		propertyChanged("_cameraY", _cameraY);
		if((_HorizontalEasing < 0))
		{
			_HorizontalEasing = asNumber(0);
			propertyChanged("_HorizontalEasing", _HorizontalEasing);
		}
		if((_VerticalEasing < 0))
		{
			_VerticalEasing = asNumber(0);
			propertyChanged("_VerticalEasing", _VerticalEasing);
		}
		_HorizontalEasing += 1;
		propertyChanged("_HorizontalEasing", _HorizontalEasing);
		_VerticalEasing += 1;
		propertyChanged("_VerticalEasing", _VerticalEasing);
		runLater(1000 * 0.02, function(timeTask:TimedTask):Void
		{
			_Started = true;
			propertyChanged("_Started", _Started);
		}, actor);
		
		/* ======================== When Updating ========================= */
		addWhenUpdatedListener(null, function(elapsedTime:Float, list:Array<Dynamic>):Void
		{
			if(wrapper.enabled)
			{
				/* "Detects the max distance the camera has moved so far." */ if((_Started && (getScreenX() > _maxX)))
				{
					_maxX = asNumber(getScreenX());
					propertyChanged("_maxX", _maxX);
				}
				/* "Controls how far backwards the camera/player can move." */ if((_BackwardsDist == 0))
				{
					_leftX = asNumber(_maxX);
					propertyChanged("_leftX", _leftX);
				}
				else if((0 < _BackwardsDist))
				{
					_leftX = asNumber((_maxX - _BackwardsDist));
					propertyChanged("_leftX", _leftX);
				}
				/* "Prevents the player from leaving the left side of the screen." */ if(((actor.getXVelocity() < 0) && (actor.getX() <= _leftX)))
				{
					actor.setX(_leftX);
					actor.setXVelocity(0);
				}
				if((actor.getX() <= 0))
				{
					actor.setX(0);
				}
				/* "Detects if the player is facing left or right." */ if((isKeyPressed(_LookLeftControl) && !(isKeyDown(_LookRightControl))))
				{
					_FacingLeft = true;
					propertyChanged("_FacingLeft", _FacingLeft);
				}
				else if((isKeyPressed(_LookRightControl) && !(isKeyDown(_LookLeftControl))))
				{
					_FacingLeft = false;
					propertyChanged("_FacingLeft", _FacingLeft);
				}
				/* "Controls the horizontal easing." */ if(_FacingLeft)
				{
					if((_lookAhead < _LookAheadDistance))
					{
						_lookAhead = asNumber((_lookAhead + ((_LookAheadDistance - _lookAhead) / (_HorizontalEasing / 2))));
						propertyChanged("_lookAhead", _lookAhead);
					}
				}
				else
				{
					if((-(_LookAheadDistance) < _lookAhead))
					{
						_lookAhead = asNumber((_lookAhead + ((-(_LookAheadDistance) - _lookAhead) / (_HorizontalEasing / 2))));
						propertyChanged("_lookAhead", _lookAhead);
					}
				}
				/* "Adjusts the camera's x position with horizontal easing." */ if((actor.getXCenter() <= ((_leftX + (getScreenWidth() / 2)) - -(_lookAhead))))
				{
					_cameraX = asNumber((_cameraX + (((_leftX + (getScreenWidth() / 2)) - _cameraX) / (_HorizontalEasing * 2))));
					propertyChanged("_cameraX", _cameraX);
					_lookAhead2 = asNumber((_lookAhead2 + (-(_lookAhead2) / (_HorizontalEasing * 2))));
					propertyChanged("_lookAhead2", _lookAhead2);
				}
				else if((actor.getXCenter() >= (((getSceneWidth()) - (getScreenWidth() / 2)) - -(_lookAhead))))
				{
					_cameraX = asNumber((_cameraX + ((((getSceneWidth()) - (getScreenWidth() / 2)) - _cameraX) / (_HorizontalEasing * 2))));
					propertyChanged("_cameraX", _cameraX);
					_lookAhead2 = asNumber((_lookAhead2 + (-(_lookAhead2) / (_HorizontalEasing * 2))));
					propertyChanged("_lookAhead2", _lookAhead2);
				}
				else
				{
					_cameraX = asNumber((_cameraX + ((actor.getXCenter() - _cameraX) / (_HorizontalEasing * 2))));
					propertyChanged("_cameraX", _cameraX);
					_lookAhead2 = asNumber((_lookAhead2 + ((_lookAhead - _lookAhead2) / (_HorizontalEasing * 2))));
					propertyChanged("_lookAhead2", _lookAhead2);
				}
				/* "Adjusts the camera's y position with vertical easing." */ if((actor.getYCenter() <= (getScreenHeight() / 2)))
				{
					_cameraY = asNumber((_cameraY + (((getScreenHeight() / 2) - _cameraY) / _VerticalEasing)));
					propertyChanged("_cameraY", _cameraY);
				}
				else if((actor.getYCenter() >= ((getSceneHeight()) - (getScreenHeight() / 2))))
				{
					_cameraY = asNumber((_cameraY + ((((getSceneHeight()) - (getScreenHeight() / 2)) - _cameraY) / _VerticalEasing)));
					propertyChanged("_cameraY", _cameraY);
				}
				else
				{
					_cameraY = asNumber((_cameraY + ((actor.getYCenter() - _cameraY) / _VerticalEasing)));
					propertyChanged("_cameraY", _cameraY);
				}
				/* "Finally, positions the camera." */ engine.moveCamera((_cameraX - _lookAhead2), _cameraY);
			}
		});
		
	}
	
	override public function forwardMessage(msg:String)
	{
		
	}
}