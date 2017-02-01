stacksize max; //Allocating maximum memory

mmm = messagebox('Please enter the input folder', 'Input Folder','modal');
if mmm == 1 then
    A = uigetdir(); //Assigning folder containing image sequence
else 
    A = [];
    end
mm = messagebox('Please enter the output folder', 'Output Folder','modal');
if mm == 1 then
    outputDir = uigetdir(); //Assigning output folder
else
    outputDir = [];
    end

px_m = 143 * (10^-6);
u_f = 1.002 * (10^-3);
u_b = 1.846 * (10^-5);
rho_b = 1.204;
rho_f = 998.2;
g = 9.87;

function f = calc_mat(a, b, c, d, e, h, j)
	f = sqrt(abs(a / (2/25) * b * (3/2) * c * (2 * c + 3 * d) * (1/j) * (1/(e - h)) * (1/(c+ d))))*(10^6);
endfunction

for i = 500:250:3000
	ii = msprintf("%1.0f",i);
	filepath1 = [A + '/' + 'Matrix_magnitude' + '/' + ii + '.txt'];
	m_k = fscanfMat(filepath1);
	c_m = calc_mat(m_k, px_m, u_f, u_b, rho_b, rho_f, g);
	mkdir(outputDir + '\' + 'Matrix_radius'+ '\');
	filepath2 = [outputDir + '\' + 'Matrix_radius' + '\' + ii + '.txt'];
	fprintfMat (filepath2,c_m,"%5.4f");
end


