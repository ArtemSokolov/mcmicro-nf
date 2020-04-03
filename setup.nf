#!/usr/bin/env nextflow

params.tools    = "$HOME/mcmicro"
params.platform = "local"

process setup_illumination {
    publishDir params.tools, mode: 'copy'

    output:
    file '**' into tool_ilp

    when:
    params.platform == "O2"
    
    """
    wget https://downloads.imagej.net/fiji/latest/fiji-linux64.zip && \
      unzip fiji-linux64.zip && rm fiji-linux64.zip

    wget https://www.helmholtz-muenchen.de/fileadmin/ICB/software/BaSiC/BaSiCPlugin.zip && \
      unzip BaSiCPlugin.zip && \
      mv BaSiCPlugin/BaSiC_.jar Fiji.app/plugins/ && \
      mv BaSiCPlugin/Dependent/*.jar Fiji.app/jars/ && \
      rm -r BaSiCPlugin.zip BaSiCPlugin __MACOSX

    rm Fiji.app/jars/jtransforms-2.4.jar

    git clone https://github.com/labsyspharm/basic-illumination.git
    cd basic-illumination
    git checkout tags/1.0.0
    """
}

process setup_coreograph {
    publishDir params.tools, mode: 'copy'

    output:
    file '**' into tool_core
    
    """
    git clone https://github.com/HMS-IDAC/Coreograph.git
    cd Coreograph
    git checkout 8bb702c0b1f36c81fa15efe2095aeb425caee7fb
    curl -o TMAsegmentation/model1.mat https://mcmicro.s3.amazonaws.com/models/model1.mat
    """
}

process setup_unmicst {
    publishDir params.tools, mode: 'copy'

    output:
    file '**' into tool_unmicst

    when:
    params.platform == "O2"

    """
    git clone https://github.com/HMS-IDAC/UnMicst.git
    cd UnMicst
    git checkout tags/1.0.0
    """
}

process setup_s3segmenter {
    publishDir params.tools, mode: 'copy'

    output:
    file '**' into tool_s3seg

    when:
    params.platform == "O2"
    
    """
    git clone https://github.com/HMS-IDAC/S3segmenter.git
    cd S3segmenter
    git checkout tags/0.2.1
    """
}

process setup_quantification {
    publishDir params.tools, mode: 'copy'

    output:
    file '**' into tool_quant

    when:
    params.platform == "O2"

    """
    git clone https://github.com/labsyspharm/quantification
    cd quantification
    git checkout tags/1.1.0
    """
}
