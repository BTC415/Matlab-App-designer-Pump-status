function varargout = Pump(varargin)
% PUMP MATLAB code for Pump.fig
%      PUMP, by itself, creates a new PUMP or raises the existing
%      singleton*.
%
%      H = PUMP returns the handle to a new PUMP or the handle to
%      the existing singleton*.
%
%      PUMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PUMP.M with the given input arguments.
%
%      PUMP('Property','Value',...) creates a new PUMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Pump_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Pump_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Pump

% Last Modified by GUIDE v2.5 15-May-2023 15:56:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pump_OpeningFcn, ...
                   'gui_OutputFcn',  @Pump_OutputFcn, ...
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


% --- Executes just before Pump is made visible.
function Pump_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Pump (see VARARGIN)

% Choose default command line output for Pump
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Pump wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Pump_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Open the file for reading
% Open a dialog box for the user to select a file
[filename, pathname] = uigetfile('*.txt', 'Select a text file'); % open dialog box to select file
if isequal(filename,0)
   disp('User selected Cancel');
else
   disp(['User selected ', fullfile(pathname, filename)]);
end

fileID = fopen(fullfile(pathname, filename),'r'); % open the selected file in read mode


% Read the data using textscan
formatSpec = '%f V,%f counts,%f ms';
global voltage count_number time_interval

data = textscan(fileID, formatSpec);
% Access the data
voltage = data{1};
count_number = data{2};
time_interval = data{3};

endn=length(voltage);
v_s=5.0;
count_reference=330;
density_water=997;
gravity=9.81;
pressure=1/0.0018*(voltage./v_s-0.04);
head=pressure./density_water./gravity*1000;
flow_rate=count_number/count_reference*1000./time_interval;
hydraulic_power=pressure.*flow_rate;
vvoltage=[];
ccount_number=[];
ttime_interval=[];
ppressure=[];
fflow_rate=[];
hhead=[];
hhydraulic_power=[];
val=get(handles.popupmenu1, 'Value');
 axes(handles.axes1);
 cla;
switch val
    case 1
        for i=1:1:endn
            ttime_interval=[ttime_interval, time_interval(i)*i/1000];
            ppressure=[ppressure, pressure(i)]
            plot(handles.axes1,ttime_interval,ppressure);
            xlabel('Time, (s)')
            ylabel('Pressure, (kPa)')
            title('Pressure vs.Time')
        end
    case 2
         
        for i=1:1:endn
            ttime_interval=[ttime_interval, time_interval(i)*i/1000];
            fflow_rate=[fflow_rate, flow_rate(i)];
            plot(handles.axes1,ttime_interval,fflow_rate);
            xlabel('Time, (s)')
            ylabel('Flow rate, (L/s)')
            title('Flow rate vs.Time')
        end
      case 3
          
          for i=1:1:endn
            hhead=[hhead, head(i)];
            fflow_rate=[fflow_rate, flow_rate(i)];
            plot(handles.axes1,fflow_rate,hhead);
            xlabel('Flow rate, (L/s)')
            ylabel('Head, (m)')
            title('Head vs.Flow rate')
        end
      case 4
         
          for i=1:1:endn
            hhydraulic_power=[hhydraulic_power, hydraulic_power(i)];
            fflow_rate=[fflow_rate, flow_rate(i)];
            plot(handles.axes1,fflow_rate,hhydraulic_power);
            xlabel('Flow rate, (L/s)')
            ylabel('Hydraulic power, (kW)')
            title('Hydraulic power vs.Flow rate')
        end
end 


        

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
