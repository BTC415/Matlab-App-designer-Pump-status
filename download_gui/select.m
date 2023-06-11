function varargout = select(varargin)
% SELECT MATLAB code for select.fig
%      SELECT, by itself, creates a new SELECT or raises the existing
%      singleton*.
%
%      H = SELECT returns the handle to a new SELECT or the handle to
%      the existing singleton*.
%
%      SELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECT.M with the given input arguments.
%
%      SELECT('Property','Value',...) creates a new SELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before select_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to select_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help select

% Last Modified by GUIDE v2.5 21-May-2023 13:05:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @select_OpeningFcn, ...
                   'gui_OutputFcn',  @select_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before select is made visible.
function select_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to select (see VARARGIN)

% Choose default command line output for select
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes select wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = select_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default output from handles 
varargout{1} = handles.output;





% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

open untitled3.fig
close select.fig





% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.L == 0
    %checking Data
    try
        %check
        handles.test = fopen(handles.filename);
    catch
        warning('Nothing has been selected');
        return;
    end
elseif handles.L == 1
    try
        %COM Port Name
        handles.test = serial('COM6');
        %Open
        fopen(handles.test);
    catch
        warning('Live Data doesnt exist');
        return;
    end
end
    %Variables
    handles.Counting_Time = [];
    handles.ps = [];
    handles.FR = [];
    handles.hs = [];
    handles.HPs = [];
    handles.Total_time = 0;
    
    %Creation of Figures
    figure();
    
    subplot(2,2,1);
    handles.pPlot = plot(NaN, NaN, '-');
    xlabel('Time');
    ylabel('Pressure');
    title('Time vs Pressure');


    subplot(2,2,2);
    handles.fPlot = plot(NaN, NaN, '-');
    xlabel('Time');
    ylabel('Flow Rate');
    title('Time vs Flow');

    subplot(2,2,3);
    handles.hPlot = plot(NaN, NaN, '.');
    xlabel('Flow Rate');
    ylabel('Head');pre
    title('Head vs Flow Rate');

    subplot(2,2,4);
    handles.HPlot = plot(NaN, NaN, '.');
    xlabel('Flow Rate');
    ylabel('Hydrolic Power');
    title({'Hydrolic Power'; 'vs Flow Rate '});

    %Timer
    handles.counter = 0;
    handles.background_timer = timer('TimerFcn', {@timer_callback, hObject}, ...
        'Period', 0.5, ...
        'ExecutionMode', 'fixedSpacing');

    %Start
    guidata(hObject,handles);
    start(handles.background_timer);


function timer_callback(~,~,hObject)
    handles = guidata(hObject);

    %timer is running
    handles.A = fgetl(handles.test);
    handles.Data = sscanf(handles.A,'%f V,%f counts,%f ms');
    handles.Volts = handles.Data(1)
    handles.Counts = handles.Data(2);
    handles.time = (handles.Data(3)/1000);


    handles.Total_time = handles.time + handles.Total_time;
    handles.Counting_Time(end + 1) = handles.Total_time;

    handles.S = 5;
    %Calculations 
    handles.p = (((handles.Volts/handles.S)-0.04)/0.0018);
    handles.ps(end + 1) = handles.p;

    handles.Litres = handles.Counts/330;
    handles.Flow_Rate = handles.Litres / handles.time;
    handles.FR(end + 1) = handles.Flow_Rate;

    handles.Head = handles.p/(9.81);
    handles.hs(end + 1) = handles.Head;

    handles.HP = (handles.Flow_Rate*handles.p);
    handles.HPs(end + 1) = handles.HP;
    disp([handles.Flow_Rate handles.p handles.Head handles.HP]);

    handles.pPlot.XData = handles.Counting_Time;
    handles.pPlot.YData = handles.ps;

    handles.fPlot.XData = handles.Counting_Time;
    handles.fPlot.YData = handles.FR;

    handles.hPlot.XData = handles.FR;
    handles.hPlot.YData = handles.hs;

    handles.HPlot.XData = handles.FR;
    handles.HPlot.YData = handles.HPs;
    
    %stop code
    if feof(handles.test) == true
        return;
    end
    
    %Update handles values
    guidata(hObject,handles);
    


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.L = 0;
[file, path] = uigetfile('*txt');
handles.filename = [path file];
guidata(hObject, handles);


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pushbutton3.
function pushbutton3_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
