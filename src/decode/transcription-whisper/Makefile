# make file to transcribe audio with kaldi
# copied and modified from https://github.com/alumae/kaldi-offline-transcriber
# see Licenses/LICENSE.alumae

-include Makefile.options

OUTPUT_ROOT?=/decoded
INPUT_ROOT?=/audio.prepared

.SECONDARY:
.DELETE_ON_ERROR:

log=echo $$(date +'%Y-%m-%d %T')
logb=$(log): START
loge=$(log): END

PYTHONPATH?=/app
PYTHON_SCRIPTS_DIR?=/app/scripts
###############################################################################
DIARIZATION_APP?=python3 $(PYTHON_SCRIPTS_DIR)/whisper.py
SEND_METRIC_APP?=${APP_DIR}/send.metric
###############################################################################
## for metrics
SHELL=$(APP_DIR)/m_shell.sh
.ONESHELL:
.EXPORT_ALL_VARIABLES:
worker=transcription-whisper
###############################################################################

# transcription with whisper
$(OUTPUT_ROOT)/trans/%/res.whisper: $(INPUT_ROOT)/%/prepared.wav
	tsk=whisper;id=$*;. $(APP_DIR)/m_start.sh $@
	mkdir -p `dirname $@`
	$(DIARIZATION_APP) --input=$^ --output=$@

$(OUTPUT_ROOT)/trans/%/.whisper.done: $(OUTPUT_ROOT)/trans/%/res.whisper
		touch $@


info:
	echo OUTPUT_ROOT=$(OUTPUT_ROOT)
	echo PYTHONPATH=$(PYTHONPATH)
	echo PYTHON_SCRIPTS_DIR=$(PYTHON_SCRIPTS_DIR)
	echo DIARIZATION_APP=$(DIARIZATION_APP)
	echo APP_DIR=$(APP_DIR)
	echo SHELL=$(SHELL)

