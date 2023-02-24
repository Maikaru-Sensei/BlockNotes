// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11.0;

/**
 * Store all notes of all addresses in this contract
 * @title BlockNotes contract
**/
contract BlockNotes {

    /**
     * represents a single note
     * @param noteId unique identifier for a note
     * @param message message which should be stored
     * @param date datetime of taking the note (epoche)
     * @param location location of taking the note
    **/
    struct Note {
        string noteId;
        string message;
        uint date;
        string location;
    }

    mapping(address => string[]) private blockNotes;
    mapping(string => Note) private noteIdMap;

    function addOrUpdateNote(address _owner, string memory _noteId, string memory _message, uint _date, string memory _location) public {
        noteIdMap[_noteId] = Note(
            _noteId,
            _message,
            _date,
            _location
        );

        if (!isUpdate(_owner, _noteId)) {
            blockNotes[_owner].push(_noteId);
        } 
    }

    function isUpdate(address _owner, string memory _noteId) private view returns(bool) {
        string[] memory notes = blockNotes[_owner];

        for (uint check = 0; check < notes.length; check++) {
            if (keccak256(bytes(notes[check])) == keccak256(bytes(_noteId))) {
                return true;
            }
        }

        return false;
    }

    function getNotes(address _owner) public view returns(Note[] memory) {
        string[] memory noteIds = blockNotes[_owner];

        Note[] memory notes = new Note[](noteIds.length);
        
        for (uint note = 0; note < noteIds.length; note++) {
            notes[note] = noteIdMap[noteIds[note]];
        }

        return notes;
    }
}
