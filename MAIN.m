% =========================================================================
% =========================================================================
%                             COMPANY NAME     
% =========================================================================
% =========================================================================

% Developed by: NAMES
% GROUP: ABC
% University of Ottawa
% Mechanical Engineering
% Latest Revision: DATE

% =========================================================================
% SOFTWARE DESCRIPTION
% =========================================================================


function varargout = MAIN(varargin)
% MAIN MATLAB code for MAIN.fig
%      MAIN, by itself, creates a new MAIN or raises the existing
%      singleton*.
%
%      H = MAIN returns the handle to a new MAIN or the handle to
%      the existing singleton*.
%
%      MAIN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MAIN.M with the given input arguments.
%
%      MAIN('Property','Value',...) creates a new MAIN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before MAIN_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to MAIN_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help MAIN

% Last Modified by GUIDE v2.5 18-Oct-2018 16:35:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @MAIN_OpeningFcn, ...
                   'gui_OutputFcn',  @MAIN_OutputFcn, ...
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

% --- Outputs from this function are returned to the command line.
function varargout = MAIN_OutputFcn(hObject, eventdata, handles) %#ok
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% End initialization code - DO NOT EDIT

% =========================================================================
% =========================================================================
% --- Executes just before MAIN is made visible.
% =========================================================================
% =========================================================================

function MAIN_OpeningFcn(hObject, eventdata, handles, varargin) %#ok
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to MAIN (see VARARGIN)

% Choose default command line output for MAIN
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Set the default values on the GUI. It is recommended to choose a valid set 
%of default values as a starting point when the program launches.
clc
Default_diameter=50;
set(handles.SliderDiameter,'Value',Default_diameter);
set(handles.TXTdiameter,'String',num2str(Default_diameter));
set(handles.BoltHoles,'Value',3); %The 3rd item of the list is selected. Change the list from the GUIDE.
set(handles.TXT_facewidth,'String','21.25');

%Set the window title with the group identification:
set(handles.figure1,'Name','Group ABC // CADCAM 2013');

%Add the 'subfunctions' folder to the path so that subfunctions can be
%accessed
addpath('Subfunctions');

% =========================================================================

% --- Executes on button press in BTN_Generate.
function BTN_Generate_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to BTN_Generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if(isempty(handles))
    Wrong_File();
else
    %Get the design parameters from the interface (DO NOT PERFORM ANY DESIGN CALCULATIONS HERE)
    diameter = get(handles.SliderDiameter,'Value');
    COMBOcontents = cellstr(get(handles.BoltHoles,'String')); %returns BoltHoles contents as cell array
    number_of_bolts = str2double(COMBOcontents{get(handles.BoltHoles,'Value')}); %returns selected item from BoltHoles
    cylinder_width = str2double(get(handles.TXT_facewidth,'String'));
    
    %Perform basic range checking (for those that can go out of range)
    if isnan(cylinder_width) || (cylinder_width <=0) || (cylinder_width > 50)
        msgbox('The cylinder face width specified is not an acceptable value. Please correct it.','Cannot generate!','warn');
        return;
    end
     
    %The design calculations are done within this function. This fonction is in
    %the file Design_code.m
    Design_code(diameter, number_of_bolts, cylinder_width);

    %Show the results on the GUI.
    log_file = 'C:\groupABC\Log\groupABC_LOG.TXT';
    fid = fopen(log_file,'r'); %Open the log file for reading
    S=char(fread(fid)'); %Read the file into a string
    fclose(fid);

    set(handles.TXT_log,'String',S); %write the string into the textbox
    set(handles.TXT_path,'String',log_file); %show the path of the log file
    set(handles.TXT_path,'Visible','on');
end

% =========================================================================

% --- Executes on button press in BTN_Finish.
function BTN_Finish_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to BTN_Finish (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close gcf

% =========================================================================

% --- Gives out a message that the GUI should not be executed directly from
% the .fig file. The user should run the .m file instead.
function Wrong_File()
clc
h = msgbox('You cannot run the MAIN.fig file directly. Please run the program from the Main.m file directly.','Cannot run the figure...','error','modal');
uiwait(h);
disp('You must run the MAIN.m file. Not the MAIN.fig file.');
disp('To run the MAIN.m file, open it in the editor and press ');
disp('the green "PLAY" button, or press "F5" on the keyboard.');
close gcf

function TXTdiameter_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to TXTdiameter (see GCBO) 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TXTdiameter as text
%        str2double(get(hObject,'String')) returns contents of TXTdiameter as a double

if(isempty(handles))
    Wrong_File();
else
    value = round(str2double(get(hObject,'String')));

    %Apply basic testing to see if the value does not exceed the range of the
    %slider (defined in the gui)
    if(value<get(handles.SliderDiameter,'Min'))
        value = get(handles.SliderDiameter,'Min');
    end
    if(value>get(handles.SliderDiameter,'Max'))
        value = get(handles.SliderDiameter,'Max');
    end
    set(hObject,'String',value);
    set(handles.SliderDiameter,'Value',value);
end

% =========================================================================
% =========================================================================
% The functions below are created by the GUI. Do not delete any of them! 
% Adding new buttons and inputs will add more callbacks and createfcns.
% =========================================================================
% =========================================================================


function TXT_log_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to TXT_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TXT_log as text
%        str2double(get(hObject,'String')) returns contents of TXT_log as a double

% --- Executes during object creation, after setting all properties.
function TXT_log_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to TXT_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on slider movement.
function SliderDiameter_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to SliderDiameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

if(isempty(handles))
    Wrong_File();
else
    value = round(get(hObject,'Value')); %Round the value to the nearest integer
    set(handles.TXTdiameter,'String',num2str(value));
end

% --- Executes during object creation, after setting all properties.
function SliderDiameter_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to SliderDiameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes during object creation, after setting all properties.
function TXTdiameter_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to TXTdiameter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in BoltHoles.
function BoltHoles_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to BoltHoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns BoltHoles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from BoltHoles


% --- Executes during object creation, after setting all properties.
function BoltHoles_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to BoltHoles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function TXT_facewidth_Callback(hObject, eventdata, handles) %#ok
% hObject    handle to TXT_facewidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TXT_facewidth as text
%        str2double(get(hObject,'String')) returns contents of TXT_facewidth as a double


% --- Executes during object creation, after setting all properties.
function TXT_facewidth_CreateFcn(hObject, eventdata, handles) %#ok
% hObject    handle to TXT_facewidth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
