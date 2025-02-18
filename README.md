
# Team3 Functional Annotation

## Bacterial Genome Annotation
This pipeline is meant to perform functional annotation of bacterial genomes that have short reads. The pipeline uses both homology-based and ab-initio approaches. The pipeline is set to take in gff, fna and faa files from gene prediction as inputs.

## Dependencies
This pipeline uses a conda environment for some dependencies. 
We recommend that you download and install Miniconda from https://conda.io/en/latest/miniconda.html

Example for installing Miniconda for Linux :

```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
./Miniconda3-latest-Linux-x86_64.sh
rm  Miniconda3-latest-Linux-x86_64.sh
```
Next, clone the repository into your local system:

```
git clone  https://github.gatech.edu/compgenomics2019/Team3-FunctionalAnnotation.git
#or
git clone git@github.gatech.edu:compgenomics2019/Team3-FunctionalAnnotation.git
```
Create and activate a conda environment using the yml file provided:

```
#Create environment after downloading yml file
conda env create -f function_annotation.yml

#Activate the conda environment:
conda activate function_annotation
```
For all the tools below add the exectuables to your PATH environment variable.
- CD-HIT

  Visit the CD-HIT github page for the latest release: https://github.com/weizhongli/cdhit

  ```
  git clone https://github.com/weizhongli/cdhit.git
  cd cdhit/
  make
  ```
  
- eggNOG

  Visit the eggNOG installation page for more detailed instructions https://github.com/eggnogdb/eggnog-mapper/wiki/Installation. Note that the eggNOG databases are large around 70 GB.

  ```
  git clone https://github.com/jhcepas/eggnog-mapper.git
  cd eggnog-mapper
  ./download_eggnog_data.py bact
  ```

- Infernal and Rfam

  Infernal may be obtained from bioconda:

  ```
  conda install -c bioconda infernal=1.1.2
  ```

  To download the Rfam database, use the `dependencies/prepare_Rfam.sh` script.

  ```
  (cd dependencies; ./prepare_Rfam.sh)
  ```

- InterProScan

  Follow the InterProScan installation steps at https://github.com/ebi-pf-team/interproscan/wiki/HowToDownload for detailed instructions and make sure to install the PANTHER database. 
  ```
  mkdir my_interproscan
  cd my_interproscan
  wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.33-72.0/interproscan-5.33-72.0-64-bit.tar.gz
  wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.33-72.0/interproscan-5.33-72.0-64-bit.tar.gz.md5
  tar -pxvzf interproscan-5.33-72.0-*-bit.tar.gz
  
  wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-12.0.tar.gz
  wget ftp://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/data/panther-data-12.0.tar.gz.md5
  md5sum -c panther-data-12.0.tar.gz.md5
  cd [InterProScan5 home]/data
  tar -pxvzf panther-data-12.0.tar.gz
  ```

- Phobius

  To download the phobius program, use the `dependencies/prepare_phobius.sh` script

  ```
  (cd dependencies; ./prepare_phobius.sh)
  ```
  
- CARD: 

  Visit the CARD installation page for more detailed instructions https://card.mcmaster.ca/download. 
  The rgi tool is installed as a part of the conda envrionment above.

- SignalP

  The SignalP software can be downloaded from http://www.cbs.dtu.dk/cgi-bin/sw_request?signalp by following the instructions mentioned on the webpage. The tool is available as an online utility as well.
  
  ```
  cd directory_for_SignalP
  tar -xvzf signalp-5.0.tar.gz
  ```
  
- LipoP

  The LipoP software can be downloaded from http://www.cbs.dtu.dk/cgi-bin/sw_request?lipop by following the instructions mentioned on the webpage. The tool is available as an online utility as well.
  
  LipoP was used to validate and compare the results of SignalP and not included in the final pipeline. As such, with SignalP 5.0, LipoP is not required as signalP performs its function as well.
  
  ```
  cd directory_for_LipoP
  tar -xvzf lipop-1.0a.Linux.tar.gz
  ```
  
  Once LipoP has been unzipped into the required directory, change the libdir variable to the path of the LipoP directory in the LipoP script.
  
- pilercr

  pilercr is available on https://www.drive5.com/pilercr/. It is used to locate CRISPR arrays in genomes.
  
  ```
  cd directory_for_pilercr
  tar -xvzf pilercr1.06.tar.gz
  ```
  
- CRT

  CRT can be downloaded from http://www.room220.com/crt/. It is a CRISPR recognition tool. 
  
  CRT was used to compare the results obtained from pilercr. It was not used in the final pipeline. 
  
  ```
  cd directory_for_CRT
  unzip CRT1.2-CLI.jar.zip
  ```
  ## How to Run
  
 ```
   cd Team3-FunctionalAnnotation/
   ./total_pipeline.bash -i <input_dir> -a <assembled_genome_dir> -c <card.json> -m <card_model> -o <output_name> -t <org_type>
 ```
