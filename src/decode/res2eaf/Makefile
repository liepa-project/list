# make file to transcribe audio with kaldi
# copied and modified from https://github.com/alumae/kaldi-offline-transcriber
# see Licenses/LICENSE.alumae

-include Makefile.options

OUTPUT_ROOT?=/decoded
RESULTS_ROOT?=/results

.SECONDARY:
.DELETE_ON_ERROR:

log=echo $$(date +'%Y-%m-%d %T')
logb=$(log): START
loge=$(log): END

PYTHONPATH?=/app
PYTHON_SCRIPTS_DIR?=/app/scripts
###############################################################################
RES2EAF_APP?=python3 $(PYTHON_SCRIPTS_DIR)/res2eaf.py
SEND_METRIC_APP?=${APP_DIR}/send.metric
###############################################################################
## for metrics
SHELL=$(APP_DIR)/m_shell.sh
.ONESHELL:
.EXPORT_ALL_VARIABLES:
worker=res2eaf
###############################################################################

# transcription with whisper
$(RESULTS_ROOT)/%/result.eaf: $(OUTPUT_ROOT)/trans/%/restore/lat.restored.txt
	tsk=res2eaf;id=$*;. $(APP_DIR)/m_start.sh $@
	mkdir -p `dirname $@`
	$(RES2EAF_APP) -l=$^ -o=$@

$(OUTPUT_ROOT)/trans/%/.res2eaf.done: $(RESULTS_ROOT)/%/result.eaf
	touch $@



info:
	echo OUTPUT_ROOT=$(OUTPUT_ROOT)
	echo PYTHONPATH=$(PYTHONPATH)
	echo PYTHON_SCRIPTS_DIR=$(PYTHON_SCRIPTS_DIR)
	echo DIARIZATION_APP=$(DIARIZATION_APP)
	echo APP_DIR=$(APP_DIR)
	echo SHELL=$(SHELL)

