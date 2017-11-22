
dirs = dir('images');

disp('START RUNNING TMO ALGORITHMS');

for directory=dirs'
    dir_name = directory.name;
    dir_path = sprintf('images/%s', directory.name);
    
    if isdir(dir_path) && ~strcmp(dir_name, '.') && ~strcmp(dir_name, '..')
        fprintf('----- Processing directory "%s" -----\n', dir_name);
        
        imgHDR = hdrimread(sprintf('%s/hdr_image.pfm', dir_path));
        
        h = figure(2);
        set(h, 'Name', 'Tone mapped version of the built HDR image');
        
        visualise = 0;
        
        disp('AshikhminTMO');
        imgOut = GammaTMO(AshikhminTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Ashikhmin.jpg', dir_path));
        
        disp('BanterleTMO');
        imgOut = GammaTMO(BanterleTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Banterle.jpg', dir_path));
        % Not using because it just used drago in most cases
        
        disp('BruceExpoBlendTMO');
        imgOut = BruceExpoBlendTMO(imgHDR);
        imwrite(imgOut, sprintf('%s/tmo_BruceExpoBlend.jpg', dir_path));
        % toompea4 is unrealistically blended
        
        disp('ChiuTMO');
        imgOut = GammaTMO(ChiuTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Chiu.jpg', dir_path));
        % toompea4 is unrealistically blended
        
        disp('DragoTMO');
        imgOut = GammaDrago(DragoTMO(imgHDR));
        imwrite(imgOut, sprintf('%s/tmo_Drago.jpg', dir_path));
        
        disp('DurandTMO');
        imgOut = GammaTMO(DurandTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Durand.jpg', dir_path));
        % toompea4 is too light
        
        disp('ExponentialTMO');
        imgOut = GammaTMO(ExponentialTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Exponential.jpg', dir_path));
        % toompea4 is too light
        
        disp('FattalTMO');
        imgOut = GammaTMO(FattalTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Fattal.jpg', dir_path));
        
        disp('FerwerdaTMO');
        imgOut = GammaTMO(FerwerdaTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Ferwerda.jpg', dir_path));
        
        disp('KimKautzConsistentTMO');
        imgOut = GammaTMO(KimKautzConsistentTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_KimKautzConsistent.jpg', dir_path));
        
        disp('KrawczykTMO');
        imgOut = GammaTMO(KrawczykTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Krawczyk.jpg', dir_path));
        % toompea4 is too light
        
        disp('KuangTMO');
        imgOut = GammaTMO(KuangTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Kuang.jpg', dir_path));
        
        disp('LischinskiTMO');
        imgOut = GammaTMO(LischinskiTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Lischinski.jpg', dir_path));
        
        disp('LogarithmicTMO');
        imgOut = GammaTMO(LogarithmicTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Logarithmic.jpg', dir_path));
        
        disp('MertensTMO');
        imgOut = MertensTMO(imgHDR);
        imwrite(imgOut, sprintf('%s/tmo_Mertens.jpg', dir_path));
        
        disp('NormalizeTMO');
        imgOut = GammaTMO(NormalizeTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Normalize.jpg', dir_path));
        
        disp('PattanaikVisualAdaptationStaticTMO');
        imgOut = GammaTMO(PattanaikVisualAdaptationStaticTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_PattanaikVisualAdaptationStatic.jpg', dir_path));
        % toompea4 is too dark
        
        disp('RamanTMO');
        imgOut = RamanTMO(imgHDR);
        imwrite(imgOut, sprintf('%s/tmo_Raman.jpg', dir_path));
        
        disp('ReinhardBilTMO');
        imgOut = GammaTMO(ReinhardBilTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_ReinhardBil.jpg', dir_path));
        
        disp('ReinhardDevlinTMO');
        imgOut = GammaTMO(ReinhardDevlinTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_ReinhardDevlin.jpg', dir_path));
        % ptln1 is too light
        
        disp('ReinhardTMO');
        imgOut = GammaTMO(ReinhardTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Reinhard.jpg', dir_path));
        
        disp('SchlickTMO');
        imgOut = GammaTMO(SchlickTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Schlick.jpg', dir_path));
        
        disp('TumblinRushmeierTMO');
        imgOut = GammaTMO(TumblinRushmeierTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_TumblinRushmeier.jpg', dir_path));
        
        disp('VanHaterenTMO');
        imgOut = VanHaterenTMO(imgHDR);
        imwrite(imgOut, sprintf('%s/tmo_VanHateren.jpg', dir_path));
        % niguliste is too dark
        
        disp('WardGlobalTMO');
        imgOut = GammaTMO(WardGlobalTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_WardGlobal.jpg', dir_path));
        % toompea4 is too dark
        
        disp('WardHistAdjTMO');
        imgOut = GammaTMO(WardHistAdjTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_WardHistAdj.jpg', dir_path));
        
        disp('YeeTMO');
        imgOut = GammaTMO(YeeTMO(imgHDR), 2.2, 0, visualise);
        imwrite(imgOut, sprintf('%s/tmo_Yee.jpg', dir_path));
        % toompea4 is too light
        
        
        
        
        
    end;
end;

disp('DONE RUNNING TMO ALGORITHMS');
