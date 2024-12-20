% SIMULINK Guide for    Exercise 7 -    Neural Modeling
%                                       Membrane Network Model
%
% To start the membrane network model , double click on the
% membrane_network Simulink model. This will open two windows:
% (1) the library browser containing all the Simulink blocks required to
%     build the membrane_network;
% (2) the model sheet, including a block labelled as "Injected Current",
%     which represents the current source, I_m.
%
% To build your model, simply drag and drop the components from the library
% browser to the model sheet and connect the elements appropriately. The
% properties of each block can be edited after double clicking on it.
% 
% To generate signals, double click on the Injected Current block and open
% the Signal Builder sub-block.
% 
% By default, the Signal Builder generates a 15 nA 10 ms long pulse signal.
% You can adjust its amplitude/width by dragging the top/side of the pulse
% (use the "Axes --> Set Y Snap Grid" and "Axes --> Set T Snap Grid"
% options to automatically adjust to grid lines) or by changing its
% parameters manually in panels at the bottom of the window. To generate a
% pulse train, you will have to add additional, separated pulses and delay
% them accordingly. This can be done either by copy-pasting the original
% pulse signal or by clicking on the "Add a pulse signal" in the toolbar
% at the top. The overall time range of the signals can be changed under
% the "Axes --> Change time range..." option.
% 
% Once the input signals are constructed, the model can be run by pressing
% on the "Run" button in the toolbar of the model sheet. To change
% simulation length, adjust the "Simulation stop time" parameter in the
% toolbar of the model sheet. Double click on the "Current Scope" or
% "Voltage Scope" blocks in the circuit model to see how the corresponding
% parameters develop over time.
% 
% Data from a plot in Simulink can be saved to the Matlab Workspace to
% produce a decent plot for the report. To export the Simulink simulation,
% click on the "Parameters" button (gray gear symbol) on the corresponding 
% scope figure toolbar, swithc to "Logging" page and activate the tick "Log
% data to workspace". Give a variable name to the data to save and a data
% format