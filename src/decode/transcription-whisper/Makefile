# make file to transcribe audio with kaldi
# copied and modified from https://github.com/alumae/kaldi-offline-transcriber
# see Licenses/LICENSE.alumae

-include Makefile.options

INPUT_ROOT?=/audio.prepared
OUTPUT_ROOT?=/decoded
APPS_ROOT?=/apps/whisper
RESULTS_ROOT?=/results
#njobs=1
#nthreads=4

#PATH:=utils:$(APPS_ROOT)/bin:$(PATH)
###export train_cmd=run.pl
###export decode_cmd=run.pl

PYTHONPATH?=/app
PYTHON_SCRIPTS_DIR?=transcription
###############################################################################
TRANS_APP?=python3 $(PYTHON_SCRIPTS_DIR)/whisper.py


###############################################################################
SEND_METRIC_APP?=${APP_DIR}/send.metric
###############################################################################

# init symbolic directories
transcription:
	ln -s $(APPS_ROOT)/$(PYTHON_SCRIPTS_DIR)

#utils:
#	ln -s $(APPS_ROOT)/utils

.SECONDARY:
.DELETE_ON_ERROR:

###############################################################################
## for metrics
SHELL=$(APP_DIR)/m_shell.sh
.ONESHELL:
.EXPORT_ALL_VARIABLES:
worker=transcription.whisper
###############################################################################

info:
	echo "=====================INFO=========================="
	echo "OUTPUT_ROOT=$(OUTPUT_ROOT)"
	echo "INPUT_ROOT= $(INPUT_ROOT)"
	echo "SCRIPTS_DIR=$(SCRIPTS_DIR)"
	echo "MODELS_ROOT=$(MODELS_ROOT)"
	echo "APPS_ROOT=  $(APPS_ROOT)"
	echo "==================================================="


$(OUTPUT_ROOT)/trans/%/whisper/.done: info $(OUTPUT_ROOT)/trans/%/whisper/lat.whisper.txt 
	#rm -rf `dirname $@`	
	#mkdir -p `dirname $@`
	#$(TRANS_APP) -i $(INPUT_ROOT)/$*/prepared.wav > $(RESULTS_ROOT)/$*/lat.whisper.txt
	touch $@	


$(OUTPUT_ROOT)/trans/%/whisper/lat.whisper.txt: transcription
	tsk=tr_whsp;id=$*;. $(APP_DIR)/m_start.sh $@
	rm -rf `dirname $@`	
	mkdir -p `dirname $@`
	$(TRANS_APP) -i $(INPUT_ROOT)/$*/prepared.wav > $@
	mkdir -p $(RESULTS_ROOT)/$*/
	cp  $@ $(RESULTS_ROOT)/$*/lat.whisper.txt

#$(RESULTS_ROOT)/%/lat.whisper.txt: $(OUTPUT_ROOT)/trans/%/whisper/lat.whisper.txt
#	mkdir -p $(RESULTS_ROOT)/$*/
#	cp $^ $@


.PHONY:
	info
